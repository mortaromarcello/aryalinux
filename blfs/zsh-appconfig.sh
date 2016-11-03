#!/bin/bash
set -e
set +h

cat >> /etc/shells << "EOF"
/bin/zsh
EOF

