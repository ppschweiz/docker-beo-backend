#!/bin/bash

source static.sh

echo "Backend starting..."

if [ ! -f "/data/ekklesia.ini" ]
then
  echo "ekklesia.ini not found; copying template..."
  cp /ekklesia.ini.template /data/ekklesia.ini
fi

echo "initializing members database..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini init

echo "initializing inivitations database..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /data/ekklesia.ini init

