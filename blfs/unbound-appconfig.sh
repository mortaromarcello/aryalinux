#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 88 unbound &&
useradd -c "Unbound DNS resolver" -d /var/lib/unbound -u 88 \
        -g unbound -s /bin/false unbound

}


postinstall()
{
echo "#"
}


$1
