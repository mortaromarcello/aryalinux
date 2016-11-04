#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 61 kvm

}

function postinstall()
{

cat >> /etc/sysctl.d/60-net-forward.conf << EOF
net.ipv4.ip_forward=1
EOF

}




$1
