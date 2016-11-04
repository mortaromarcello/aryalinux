#!/bin/bash
set -e
set +h

function postinstall()
{

cat >> /etc/shells << "EOF"
/bin/dash
EOF

}


preinstall()
{
echo "#"
}


$1
