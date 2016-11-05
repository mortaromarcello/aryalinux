#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep wireshark /etc/group &> /dev/null; then
groupadd -g 62 wireshark
fi
}


function preinstall()
{
echo "#"
}


$1
