#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 20 named &&
useradd -c "BIND Owner" -g named -s /bin/false -u 20 named &&
install -d -m770 -o named -g named /srv/named

}


postinstall()
{
echo "#"
}


$1
