#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:Noto-hinted:null
#VER:v2015-09-license-adobe:29

#REQ:unzip


cd $SOURCE_DIR

URL=https://github.com/googlei18n/noto-fonts/archive/v2015-09-29-license-adobe.tar.gz

wget -nc https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip
wget -nc https://github.com/googlei18n/noto-fonts/archive/v2015-09-29-license-adobe.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

install -d -m755         /usr/share/fonts/noto   &&
unzip Noto-hinted.zip -d /usr/share/fonts/noto   &&
chmod 0644               /usr/share/fonts/noto/* &&
fc-cache


install -d -m755         /usr/share/fonts/noto                                 &&
cp -v LICENSE hinted/*.ttf unhinted/NotoSansSymbols*.ttf /usr/share/fonts/noto &&
rm -v /usr/share/fonts/noto/Noto*UI*                                           &&
chmod 0644               /usr/share/fonts/noto/*                               &&
fc-cache


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "noto-fonts=>`date`" | sudo tee -a $INSTALLED_LIST

