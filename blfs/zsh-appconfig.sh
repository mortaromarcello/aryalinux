#!/bin/bash
set -e
set +h

function postinstall()
{

cat >> /etc/shells << "EOF"
/bin/zsh
EOF

}


preinstall()
{
echo "#"
}


$1
