#!/bin/bash
set -e
set +h

function postinstall()
{

echo \
'ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/srv/www/$1' >> \
/etc/httpd/httpd.conf

}


preinstall()
{
echo "#"
}


$1
