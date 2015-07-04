#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






find /usr/share/man -type f | xargs checkman.sh


 
cd $SOURCE_DIR
 
echo "locale-issues=>`date`" | sudo tee -a $INSTALLED_LIST