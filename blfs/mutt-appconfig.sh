#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep mail /etc/group &> /dev/null; then

groupadd -g 34 mail

fi

}


preinstall()
{
echo "#"
}


$1
