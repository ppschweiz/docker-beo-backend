#!/bin/bash

echo "importing private GPG-Key"
gpg --import /secrets/gpg.priv

echo "Backend starting..."

# Substitute configuration
for VARIABLE in $(env | cut -f1 -d=); do
  sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /ekklesia.ini
done
