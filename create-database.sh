#!/bin/bash

su -c 'createuser --username=postgres --no-superuser --pwprompt databaseusername' postgres
su -c 'createdb --username=postgres --owner=databaseuser --encoding=UNICODE databasename_members' postgres
su -c 'createdb --username=postgres --owner=databaseuser --encoding=UNICODE databasename_invitations' postgres

