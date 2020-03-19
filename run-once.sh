#!/bin/bash

#while true; do echo "..."; sleep 10; done

source static.sh

echo "Exporting members..."
touch /tmp/memberlist
cd /python-civi && python3 export_members.py /tmp/reset /tmp/gpg > /tmp/members.csv
if [ $? -ne 0 ]
then
	echo "Export members from civi FAILED"
	exit 1
fi

echo "Import gpg keys..."
gpg --import /tmp/gpg/*
gpg --refresh-keys --keyserver pgp.mit.edu

echo "Departments members..."
cd /python-civi && python3 export_departments.py > /tmp/departments.csv
if [ $? -ne 0 ]
then
	echo "Export departments from civi FAILED"
	exit 2
fi

echo "Importing members and departments..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /ekklesia.ini -v import -s /tmp/members.csv /tmp/departments.csv
if [ $? -ne 0 ]
then
	echo "Import members into backend FAILED"
	exit 3
fi

echo "Exporting members for transfer..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /ekklesia.ini -v export /tmp/transfer.csv
if [ $? -ne 0 ]
then
	echo "Export members from backend FAILED"
	exit 4
fi

echo "Importing invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v import -s /tmp/transfer.csv
if [ $? -ne 0 ]
then
	echo "Import invitations into backend FAILED"
	exit 5
fi
	
echo "Resetting invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v reset -u /tmp/reset
if [ $? -ne 0 ]
then
	echo "Resetting members on backend FAILED"
	exit 6
fi
rm /tmp/reset
touch /tmp/reset

echo "Syncing invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v sync
if [ $? -ne 0 ]
then
	echo "Syncing invitations with backend FAILED"
	exit 7
fi

echo "Syncing members..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /ekklesia.ini -v sync
if [ $? -ne 0 ]
then
	echo "Syncing members with backend FAILED"
	exit 8
fi

echo "Sending invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v send
if [ $? -ne 0 ]
then
	echo "Sending invitations with backend FAILED"
	exit 9
fi
	
echo "Syncing invitations..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini -v sync
if [ $? -ne 0 ]
then
	echo "Syncing invitations with backend FAILED"
	exit 10
fi

echo "Syncing members..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /ekklesia.ini -v sync
if [ $? -ne 0 ]
then
	echo "Syncing members with backend FAILED"
	exit 11
fi
