#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

PACKAGE_NAME="flat-plat-gtk-theme"
URL="https://github.com/nana-4/Flat-Plat/archive/master.zip"

wget -c $URL -O flat-plat.zip

sudo mkdir -pv /usr/share/themes/Flat-Plat/
sudo unzip flat-plat.zip -d /usr/share/themes/Flat-Plat/

cd $SOURCE_DIR

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
