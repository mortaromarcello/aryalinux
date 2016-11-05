#!/bin/bash
set -e
set +h

function postinstall()
{

if ! grep kvm /etc/group &> /dev/null; then
groupadd -g 61 kvm
fi

cat >> /etc/sysctl.d/60-net-forward.conf << EOF
net.ipv4.ip_forward=1
EOF

}

function preinstall()
{
echo "#"
}


$1
