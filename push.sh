#!/bin/bash

source static.sh

echo "Backend starting..."

echo "Waiting for rabbitmq..."
env PYTHONPATH=/ekklesia python -m ekklesia.backends.members -C /data/ekklesia.ini -v push

