#!/bin/bash
set -e
set +h

function postinstall()
{

cat >> /etc/ld.so.conf << EOF
# Begin texlive 2016 addition
/opt/texlive/2016/lib
# End texlive 2016 addition
EOF

}


preinstall()
{
echo "#"
}


$1
