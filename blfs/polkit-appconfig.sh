#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -fg 27 polkitd &&
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd

}


postinstall()
{
echo "#"
}


$1
