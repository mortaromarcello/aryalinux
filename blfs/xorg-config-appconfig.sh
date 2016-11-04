#!/bin/bash
set -e
set +h

function postinstall()
{

usermod -a -G video $(cat /tmp/currentuser)

}


preinstall()
{
echo "#"
}


$1
