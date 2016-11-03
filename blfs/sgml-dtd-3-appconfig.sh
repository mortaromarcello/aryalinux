#!/bin/bash
set -e
set +h

cat >> /usr/share/sgml/docbook/sgml-dtd-3.1/catalog << "EOF"
 -- Begin Single Major Version catalog changes --
PUBLIC "-//Davenport//DTD DocBook V3.0//EN" "docbook.dtd"
 -- End Single Major Version catalog changes --
EOF

