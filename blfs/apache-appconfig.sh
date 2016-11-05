#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep apache /etc/group &> /dev/null; then

groupadd -g 25 apache &&
useradd -c "Apache Server" -d /srv/www -g apache \
        -s /bin/false -u 25 apache

fi

}


preinstall()
{
echo "#"
}


$1
