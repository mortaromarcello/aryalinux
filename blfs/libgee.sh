#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:libgee-.orig:0.8_0.18.0

cd $SOURCE_DIR

URL=https://launchpad.net/ubuntu/+archive/primary/+files/libgee-0.8_0.18.0.orig.tar.xz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "libgee=>`date`" | sudo tee -a $INSTALLED_LIST



