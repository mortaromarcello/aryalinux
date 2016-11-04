#!/bin/bash
set -e
set +h

function postinstall()
{

cat >> /etc/shells << "EOF"
/bin/tcsh
/bin/csh
EOF

}


preinstall()
{
echo "#"
}


$1
