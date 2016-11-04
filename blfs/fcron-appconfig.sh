#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 22 fcron &&
useradd -d /dev/null -c "Fcron User" -g fcron -s /bin/false -u 22 fcron

}


postinstall()
{
echo "#"
}


$1
