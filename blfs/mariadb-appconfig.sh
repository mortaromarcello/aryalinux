#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep mysql /etc/group &> /dev/null; then

groupadd -g 40 mysql &&
useradd -c "MySQL Server" -d /srv/mysql -g mysql -s /bin/false -u 40 mysql

fi

}


preinstall()
{
echo "#"
}


$1
