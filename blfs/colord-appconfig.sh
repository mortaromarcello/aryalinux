#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep colord /etc/group &> /dev/null; then

groupadd -g 71 colord &&
useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
        -g colord -s /bin/false colord
fi

}


preinstall()
{
echo "#"
}


$1
