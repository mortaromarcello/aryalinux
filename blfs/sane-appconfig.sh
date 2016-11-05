#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep scanner /etc/group; then groupadd -g 70 scanner; fi

}


preinstall()
{
echo "#"
}


$1
