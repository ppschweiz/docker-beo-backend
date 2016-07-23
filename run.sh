#!/bin/bash

echo "Backend starting..."

if [ ! -f "/data/ekklesia.ini" ]
then
  echo "ekklesia.ini not found; copying template..."
  cp /ekklesia.ini.template /data/ekklesia.ini
fi

if [ ! -f "/data/members.sqlite" ]
then
  echo "members.sqlite not found; initializing..."
  cd /data
  env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini init
  cd /
fi

if [ ! -f "/data/invitations.sqlite" ]
then
  echo "invitations.sqlite not found; initializing..."
  cd /data
  env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini init
  cd /
fi

echo "Exporting members..."
touch /data/memberlist
cd /python-civi && python export_members.py /data/memberlist > /tmp/members.csv

echo "Departments members..."
cd /python-civi && python export_departments.py > /tmp/departments.csv

echo "Importing members and departments..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini import -s /tmp/members.csv /tmp/departments.csv

echo "Exporting members for transfer..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini export /tmp/transfer.csv

echo "Importing invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini import -s /tmp/transfer.csv

echo "Syncing invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini sync

echo "Syncing members..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini sync

echo "Sending invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini send

