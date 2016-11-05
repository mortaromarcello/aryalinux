#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep lpadmin /etc/group &> /dev/null; then

useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp
groupadd -g 19 lpadmin
usermod -a -G lpadmin $(cat /tmp/currentuser)

fi

}


preinstall()
{
echo "#"
}


$1
