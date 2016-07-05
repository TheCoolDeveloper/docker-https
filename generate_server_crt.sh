#!/bin/bash
apt-get install openssl

#Required
domain=$1
commonname=$domain

#Company details
country=IN
state=KAR
city=BLR
org=OpenSource
unit=TCD
email=sandhyanayakrait@gmail.com


echo "Generating key request for $domain"

#Generate a key
openssl req -new -x509 -nodes -out server.crt -keyout server.key  -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
