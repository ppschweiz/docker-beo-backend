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

while :
do
	echo "Exporting members..."
	touch /data/memberlist
	cd /python-civi && python3 export_members.py /data/reset /tmp/gpg > /tmp/members.csv

	echo "Import gpg keys..."
	gpg --homedir /data/gnupg/ --import /tmp/gpg/*
	gpg --homedir /data/gnupg/ --refresh-keys --keyserver pgp.mit.edu

	echo "Departments members..."
	cd /python-civi && python3 export_departments.py > /tmp/departments.csv

	echo "Importing members and departments..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini -v import -s /tmp/members.csv /tmp/departments.csv

	echo "Exporting members for transfer..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini -v export /tmp/transfer.csv

	echo "Importing invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini -v import -s /tmp/transfer.csv
	
	echo "Resetting invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini -v reset -u /data/reset
	rm /data/reset
	touch /data/reset

	echo "Syncing invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini -v sync

	echo "Syncing members..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini -v sync

	echo "Sending invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini -v send
	
	echo "Syncing invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini -v sync

	echo "Syncing members..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini -v sync

	echo "Round finished. Waiting 15 minutes..."
	sleep 300
	echo "Waiting 10 minutes..."
	sleep 300
	echo "Waiting 5 minutes..."
	sleep 300
done
