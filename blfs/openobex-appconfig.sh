#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 90 plugdev

}



postinstall()
{
echo "#"
}


$1
