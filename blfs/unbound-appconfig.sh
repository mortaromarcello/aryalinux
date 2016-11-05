#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep unbound /etc/group &> /dev/null; then

groupadd -g 88 unbound &&
useradd -c "Unbound DNS resolver" -d /var/lib/unbound -u 88 \
        -g unbound -s /bin/false unbound
fi
}


preinstall()
{
echo "#"
}


$1
