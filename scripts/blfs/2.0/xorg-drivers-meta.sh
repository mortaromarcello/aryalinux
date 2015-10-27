#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:x7driver#xorg-evdev-driver
#DEP:x7driver#xorg-synaptics-driver
#DEP:x7driver#xorg-vmmouse-driver
#DEP:x7driver#xorg-wacom-driver
#DEP:x7driver#xorg-ati-driver
#DEP:x7driver#xorg-fbdev-driver
#DEP:x7driver#xorg-intel-driver
#DEP:x7driver#xorg-nouveau-driver
#DEP:x7driver#xorg-vesa-driver
#DEP:x7driver#xorg-vmware-driver


cd $SOURCE_DIR







 
cd $SOURCE_DIR
 
echo "xorg-drivers-meta=>`date`" | sudo tee -a $INSTALLED_LIST