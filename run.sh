#!/bin/bash

#while true; do echo "..."; sleep 10; done

source static.sh

while :
do
	date

	/run-once.sh

	date
	echo "Round finished. Waiting 15 minutes..."
	sleep 300
	echo "Waiting 10 minutes..."
	sleep 300
	echo "Waiting 5 minutes..."
	sleep 300
done
