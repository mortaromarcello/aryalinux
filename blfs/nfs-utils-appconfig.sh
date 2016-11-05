#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep nogroup /etc/group &> /dev/null; then

groupadd -g 99 nogroup &&
useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup \
    -s /bin/false -u 99 nobody

fi

}


preinstall()
{
echo "#"
}


$1
