#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 62 wireshark

}


postinstall()
{
echo "#"
}


$1
