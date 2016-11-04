#!/bin/bash
set -e
set +h

function postinstall()
{

echo ca-directory=/etc/ssl/certs >> /etc/wgetrc

}


preinstall()
{
echo "#"
}


$1
