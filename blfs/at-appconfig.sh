#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 17 atd                                                  &&
useradd -d /dev/null -c "atd daemon" -g atd -s /bin/false -u 17 atd &&
mkdir -p /var/spool/cron

}


postinstall()
{
echo "#"
}


$1
