#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep rpc /etc/group &> /dev/null; then

groupadd -g 28 rpc &&
useradd -c "RPC Bind Daemon Owner" -d /dev/null -g rpc \
        -s /bin/false -u 28 rpc
fi

}


preinstall()
{
echo "#"
}


$1
