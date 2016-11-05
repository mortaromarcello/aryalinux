#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep atd /etc/group &> /dev/null; then

groupadd -g 17 atd                                                  &&
useradd -d /dev/null -c "atd daemon" -g atd -s /bin/false -u 17 atd &&
mkdir -p /var/spool/cron

fi

}


preinstall()
{
echo "#"
}


$1
