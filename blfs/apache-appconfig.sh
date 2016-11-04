#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 25 apache &&
useradd -c "Apache Server" -d /srv/www -g apache \
        -s /bin/false -u 25 apache

}


postinstall()
{
echo "#"
}


$1
