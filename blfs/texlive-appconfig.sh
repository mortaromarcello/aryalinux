#!/bin/bash
set -e
set +h

cat >> /etc/ld.so.conf << EOF
# Begin texlive 2016 addition
/opt/texlive/2016/lib
# End texlive 2016 addition
EOF

