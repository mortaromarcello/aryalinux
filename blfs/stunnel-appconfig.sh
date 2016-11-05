#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep stunnel /etc/group &> /dev/null; then

groupadd -g 51 stunnel &&
useradd -c "stunnel Daemon" -d /var/lib/stunnel \
        -g stunnel -s /bin/false -u 51 stunnel
fi

}


preinstall()
{
echo "#"
}


$1
