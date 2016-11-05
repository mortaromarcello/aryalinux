#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep proftpd /etc/group &> /dev/null; then

groupadd -g 46 proftpd                             &&
useradd -c proftpd -d /srv/ftp -g proftpd \
        -s /usr/bin/proftpdshell -u 46 proftpd     &&
install -v -d -m775 -o proftpd -g proftpd /srv/ftp &&
ln -v -s /bin/false /usr/bin/proftpdshell          &&
echo /usr/bin/proftpdshell >> /etc/shells

fi

}


preinstall()
{
echo "#"
}


$1
