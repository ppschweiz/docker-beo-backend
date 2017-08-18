# docker-beo-backend

The BEO/Televotia backend does the following:

* Download the members mail addresses, voting rights and identity verifcation from the CiviCRM
* Send new members their invitations to Televoita via email
* Synchronize members and theair voting rights and identity verifcation with the ID server 

## Requirements

You need to prepare:
* A docker host
* A Postgres database server

You need to have:
* An X509 client certificate for the ID server API complete with CA-certificate, certificate and private key
* An OpenPGP private/public key pair from the ID server and the public key of the ID server

You need to know:
* The ID server's frontend URL denoted _id-server.url_
* The ID server's API URL denoted _id-server-api.url_
* The mail address correpsonding to the OpenPGP public key of the ID server denoted as _name@id-server.url_

## Installation

### Create databases

Create two database for the _members_ and the _invitations_. You may use two seperate users. You may adapt the _create-database.sh_ script for this.

### Data Directory

The data directory _/data/_ must contains the following:
* The config file at _/data/ekklesia.ini_
* The PGP keyring at _/data/gnupg/_
* The X509 client certificate and the corresponding key

### Config file

The config file _/data/ekklesia.ini_ must be adapted from _ekklesia.ini.template_ as follows:

* In both the _members_ and the _invitations_ section:
* The ID server API URL
* Paths to the X509 client certificates and including private key
* The database connection for the corresponding database including credentials
* The SMTP server address and credential
* The GPG sender address and passphrase

The data directory must be inserted into the docker container at _/data_

### Environment variables

You must set the following environment variables when running the docker container:

* CIVI_API_URL : complete URL to the REST interfaces of your CiviCRM
* CIVI_SITE_KEY : site key for your CiviCRM
* CIVI_API_KEY : API key for your CiviCRM
* SMTP_SERVER_ADDRESS : Address for an SMTP server
* SMTP_SERVER_PORT : Port for the SMTP server
* SMTP_USERNAME : Username to log on to the SMTP server for sending
* SMTP_PASSWORD : Password for this user

### Run Docker Container

There is a template _docker-run.sh.template_ to facilitiy running the container.

## Push service

There is also a push service to update users on demand when they register with the ID server.

The push service is run by just starting the same docker image with the _push.sh_ script.

