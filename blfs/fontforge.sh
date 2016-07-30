#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:fontforge_.b.orig:20120731

#REQ:perl-modules#io-string
#REQ:perl-modules#font-ttf

URL=http://archive.ubuntu.com/ubuntu/pool/universe/f/fontforge/fontforge_20120731.b.orig.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "fontforge=>`date`" | sudo tee -a $INSTALLED_LIST
