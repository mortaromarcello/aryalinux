#!/bin/bash
set -e
set +h

groupadd -g 61 kvm

cat >> /etc/sysctl.d/60-net-forward.conf << EOF
net.ipv4.ip_forward=1
EOF

