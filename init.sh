#!/bin/bash

echo "Backend starting..."

if [ ! -f "/ekklesia.ini" ]
then
  echo "ekklesia.ini not found; copying template..."
  cp /ekklesia.ini.template /ekklesia.ini
fi

echo "initializing members database..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /ekklesia.ini init

echo "initializing inivitations database..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.invitations -C /ekklesia.ini init

