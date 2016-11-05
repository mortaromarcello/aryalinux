#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep gdm /etc/group &> /dev/null; then

groupadd -g 21 gdm &&
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
        -g gdm -s /bin/false gdm

fi

}


preinstall()
{
echo "#"
}


$1
