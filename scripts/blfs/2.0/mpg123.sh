#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-lib


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/mpg123/mpg123-1.21.0.tar.bz2


TARBALL=mpg123-1.21.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-module-suffix=.so &&
make

cat > 1434987998838.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mpg123=>`date`" | sudo tee -a $INSTALLED_LIST