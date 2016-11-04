#!/bin/bash
set -e
set +h

function postinstall()
{

cat >> /etc/sudo.conf << "EOF" &&
# Path to askpass helper program
Path askpass /usr/libexec/openssh/ssh-askpass
EOF
chmod -v 0644 /etc/sudo.conf

}


preinstall()
{
echo "#"
}


$1
