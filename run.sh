#!/bin/bash

echo "Backend starting..."

cd /etc && perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < members.ini.template > members.ini
cd /etc && perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < invitations.ini.template > invitations.ini

if [ ! -f "/data/members.sqlite" ]
then
  echo "members.sqlite not found; initializing..."
  cd /data
  env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /etc/members.ini init
  cd /
fi

if [ ! -f "/data/invitations.sqlite" ]
then
  echo "invitations.sqlite not found; initializing..."
  cd /data
  env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /etc/invitations.ini init
  cd /
fi

echo "Exporting members..."
cd /python-civi && python export_members.py > /tmp/members.csv

echo "Departments members..."
cd /python-civi && python export_departments.py > /tmp/departments.csv

echo "Importing members and departments..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /etc/members.ini import -s /tmp/members.csv /tmp/departments.csv

echo "Exporting members for transfer..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /etc/members.ini export /tmp/transfer.csv

echo "Importing invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /etc/invitations.ini import -s /tmp/transfer.csv

echo "Syncing invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /etc/invitations.ini sync

echo "Syncing members..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /etc/members.ini sync

#env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /etc/invitations.ini send

