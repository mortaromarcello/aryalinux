#!/bin/bash
set -e
set +h

function preinstall()
{

if ! grep video /etc/group &> /dev/null; then
usermod -a -G video $(cat /tmp/currentuser)
fi

}


postinstall()
{
echo "#"
}


$1
