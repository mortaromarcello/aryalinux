#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep dovecot /etc/group &> /dev/null; then

groupadd -g 42 dovecot &&
useradd -c "Dovecot unprivileged user" -d /dev/null -u 42 \
        -g dovecot -s /bin/false dovecot &&
groupadd -g 43 dovenull &&
useradd -c "Dovecot login user" -d /dev/null -u 43 \
        -g dovenull -s /bin/false dovenull

fi

}


preinstall()
{
echo "#"
}


$1
