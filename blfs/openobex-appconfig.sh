#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep plugdev /etc/group &> /dev/null; then
groupadd -g 90 plugdev
fi
}



preinstall()
{
echo "#"
}


$1
