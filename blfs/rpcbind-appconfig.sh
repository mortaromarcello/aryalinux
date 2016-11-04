#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 28 rpc &&
useradd -c "RPC Bind Daemon Owner" -d /dev/null -g rpc \
        -s /bin/false -u 28 rpc

}


postinstall()
{
echo "#"
}


$1
