#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:util-macros
#DEP:x7proto
#DEP:libXau
#DEP:libXdmcp
#DEP:xcb-proto
#DEP:libxcb
#DEP:x7lib
#DEP:xcb-util
#DEP:xcb-util-image
#DEP:xcb-util-keysyms
#DEP:xcb-util-renderutil
#DEP:xcb-util-wm
#DEP:mesalib
#DEP:xbitmaps
#DEP:x7app
#DEP:xcursor-themes
#DEP:x7font
#DEP:xkeyboard-config
#DEP:xorg-server
#DEP:x7driver
#DEP:twm
#DEP:xterm
#DEP:xclock
#DEP:xinit


cd $SOURCE_DIR




tar -xf $TARBALL



 
cd $SOURCE_DIR
 
echo "xorg-xserver-meta=>`date`" | sudo tee -a $INSTALLED_LIST