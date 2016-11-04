#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 71 colord &&
useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
        -g colord -s /bin/false colord

}


postinstall()
{
echo "#"
}


$1
