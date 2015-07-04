#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dhcpcd
#DEP:wget
#DEP:wireless_tools
#DEP:wpa_supplicant
#DEP:networkmanager
#DEP:traceroute
#DEP:curl
#DEP:network-manager-applet
#DEP:ModemManager


cd $SOURCE_DIR







 
cd $SOURCE_DIR
 
echo "network-apps=>`date`" | sudo tee -a $INSTALLED_LIST