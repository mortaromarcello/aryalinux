#!/bin/bash
set -e
set +h

install -v -d -m755 /etc/mercurial &&
cat >> /etc/mercurial/hgrc << "EOF"
[web]
cacerts = /etc/ssl/ca-bundle.crt
EOF

