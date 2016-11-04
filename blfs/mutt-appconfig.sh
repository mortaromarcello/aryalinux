#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 34 mail

}


postinstall()
{
echo "#"
}


$1
