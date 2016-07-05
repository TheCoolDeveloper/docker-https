#!/bin/bash
uncommentpatterns="ssl_module
httpd-ssl.conf
socache_shmcb_module"

for var in $uncommentpatterns
do
  sed -i "/"$var"/s/^#//g" httpd.conf
  echo $var
done

#echo Changing servername in httpd.conf
sed -i "s/www.example.com/"$1"/g" extra/httpd-ssl.conf
