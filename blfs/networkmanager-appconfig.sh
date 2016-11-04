#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep -E "^plugins=keyfile" /etc/NetworkManager/NetworkManager.conf &>/dev/null; then

cat >> /etc/NetworkManager/NetworkManager.conf << "EOF"
[main]
plugins=keyfile
EOF

fi

}


preinstall()
{
echo "#"
}


$1
