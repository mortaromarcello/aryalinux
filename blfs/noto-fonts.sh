#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:v2015-09-license-adobe:29
#VER:Noto-hinted:null

#REQ:unzip


cd $SOURCE_DIR

URL=https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip

wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip

sudo install -d -m755         /usr/share/fonts/truetype/noto &&
sudo unzip Noto-hinted.zip -d /usr/share/fonts/truetype/noto &&
sudo chmod 0644               /usr/share/fonts/truetype/noto/*


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "noto-fonts=>`date`" | sudo tee -a $INSTALLED_LIST

