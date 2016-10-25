#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:mediterranean-gtk-theme:SVN`date --iso-8601`

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

PACKAGE_NAME="mediterranean-gtk-theme"
URL="https://github.com/rbrito/mediterranean-gtk-themes/archive/master.zip"

wget -c $URL -O mediterranean-gtk-themes.zip

sudo mkdir -pv /usr/share/themes/Mediterranean/
sudo unzip flat-plat.zip -d /usr/share/themes/Mediterranean/

cd $SOURCE_DIR

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
