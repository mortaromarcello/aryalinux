#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep ntp /etc/group &> /dev/null; then

groupadd -g 87 ntp &&
useradd -c "Network Time Protocol" -d /var/lib/ntp -u 87 \
        -g ntp -s /bin/false ntp

fi

}


preinstall()
{
echo "#"
}


$1
