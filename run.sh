#!/bin/bash

#while true; do echo "..."; sleep 10; done

source static.sh

while :
do
	echo "Exporting members..."
	touch /tmp/memberlist
	cd /python-civi && python3 export_members.py /tmp/reset /tmp/gpg > /tmp/members.csv

	echo "Import gpg keys..."
	gpg --import /tmp/gpg/*
	gpg --refresh-keys --keyserver pgp.mit.edu

	echo "Departments members..."
	cd /python-civi && python3 export_departments.py > /tmp/departments.csv

	echo "Importing members and departments..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /ekklesia.ini -v import -s /tmp/members.csv /tmp/departments.csv

	echo "Exporting members for transfer..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /ekklesia.ini -v export /tmp/transfer.csv

	echo "Importing invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v import -s /tmp/transfer.csv
	
	echo "Resetting invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v reset -u /tmp/reset
	rm /tmp/reset
	touch /tmp/reset

	echo "Syncing invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v sync

	echo "Syncing members..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /ekklesia.ini -v sync

	echo "Sending invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v send
	
	echo "Syncing invitations..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v sync

	echo "Syncing members..."
	env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /ekklesia.ini -v sync

	echo "Round finished. Waiting 15 minutes..."
	sleep 300
	echo "Waiting 10 minutes..."
	sleep 300
	echo "Waiting 5 minutes..."
	sleep 300
done
