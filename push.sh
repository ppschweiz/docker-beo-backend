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

echo "Waiting for rabbitmq..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini -v push

