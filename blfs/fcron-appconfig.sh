#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep fcron /etc/group &> /dev/null; then

groupadd -g 22 fcron &&
useradd -d /dev/null -c "Fcron User" -g fcron -s /bin/false -u 22 fcron
fi

}


preinstall()
{
echo "#"
}


$1
