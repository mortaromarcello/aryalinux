#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:fonts-dejavu_.orig:2.35

#REQ:fontforge
#REQ:perl-modules#font-ttf

URL=http://archive.ubuntu.com/ubuntu/pool/main/f/fonts-dejavu/fonts-dejavu_2.35.orig.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

make full-ttf
sudo mkdir -pv /usr/share/fonts/truetype/dejavu/
sudo cp -v build/*.ttf /usr/share/fonts/truetype/dejavu/

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "fonts-dejavu=>`date`" | sudo tee -a $INSTALLED_LIST
