#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://download.icu-project.org/files/icu4c/54.1/icu4c-54_1-src.tgz


TARBALL=icu4c-54_1-src.tgz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cd source &&
./configure --prefix=/usr &&
make

cat > 1434987998757.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998757.sh
sudo ./1434987998757.sh
sudo rm -rf 1434987998757.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "icu=>`date`" | sudo tee -a $INSTALLED_LIST