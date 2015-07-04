#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.mega-nerd.com/SRC/libsamplerate-0.1.8.tar.gz


TARBALL=libsamplerate-0.1.8.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998836.sh << "ENDOFFILE"
make htmldocdir=/usr/share/doc/libsamplerate-0.1.8 install
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libsamplerate=>`date`" | sudo tee -a $INSTALLED_LIST