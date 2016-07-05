#!/bin/bash
uncommentpatterns="proxy_module
proxy_ajp_module
proxy_http_module"

for var in $uncommentpatterns
do
  sed -i "/"$var"/s/^#//g" httpd.conf
  echo $var
done
sed -i '/ServerName www/s/^#//g' httpd.conf
echo domain name is $1

echo Changing servername in httpd.conf
sed -i "s/www.example.com/"$1"/g" httpd.conf
