#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtksourceview2
#DEP:mousepad
#DEP:vte2
#DEP:xfce4-terminal
#DEP:xfburn
#DEP:ristretto
#DEP:libunique
#DEP:xfce4-mixer
#DEP:xfce4-notifyd


cd $SOURCE_DIR







 
cd $SOURCE_DIR
 
echo "xfce-apps-meta=>`date`" | sudo tee -a $INSTALLED_LIST