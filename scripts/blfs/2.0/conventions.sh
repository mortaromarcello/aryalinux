#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






./configure --prefix=/usr

cat > $LFS/etc/group << "EOF"
root:x:0:
bin:x:1:
......
EOF


 
cd $SOURCE_DIR
 
echo "conventions=>`date`" | sudo tee -a $INSTALLED_LIST