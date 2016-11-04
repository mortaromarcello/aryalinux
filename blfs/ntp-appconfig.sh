#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 87 ntp &&
useradd -c "Network Time Protocol" -d /var/lib/ntp -u 87 \
        -g ntp -s /bin/false ntp

}


postinstall()
{
echo "#"
}


$1
