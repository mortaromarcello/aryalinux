#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:Noto-hinted:null
#VER:v2015-09-license-adobe:29

#REQ:unzip


cd $SOURCE_DIR

#URL=https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip
#wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip

wget -nc https://github.com/googlei18n/noto-fonts/archive/v2015-09-29-license-adobe.tar.gz

install -d -m755                           /usr/share/fonts/truetype/noto &&
tar xf v2015-09-29-license-adobe.tar.gz -C /usr/share/fonts/truetype/noto &&
chmod 0644                                 /usr/share/fonts/truetype/noto/*


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "noto-fonts=>`date`" | sudo tee -a $INSTALLED_LIST

