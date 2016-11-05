#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep polkitd /etc/group &> /dev/null; then

groupadd -fg 27 polkitd &&
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd
fi

}


preinstall()
{
echo "#"
}


$1
