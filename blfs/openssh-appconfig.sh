#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep sshd /etc/group &> /dev/null; then

install  -v -m700 -d /var/lib/sshd &&
chown    -v root:sys /var/lib/sshd &&
groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd

fi
}


preinstall()
{
echo "#"
}


$1
