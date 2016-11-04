#!/bin/bash
set -e
set +h

function preinstall()
{

if ! grep scanner /etc/group; then groupadd -g 70 scanner; fi

}


postinstall()
{
echo "#"
}


$1
