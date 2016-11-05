#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep avahi /etc/group &> /dev/null; then

groupadd -fg 84 avahi &&
useradd -c "Avahi Daemon Owner" -d /var/run/avahi-daemon -u 84 \
        -g avahi -s /bin/false avahi

groupadd -fg 86 netdev

fi

}


preinstall()
{
echo "#"
}


$1
