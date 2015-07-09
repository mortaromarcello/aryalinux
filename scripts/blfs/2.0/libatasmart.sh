#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://0pointer.de/public/libatasmart-0.19.tar.xz


TARBALL=libatasmart-0.19.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998759.sh << "ENDOFFILE"
make docdir=/usr/share/doc/libatasmart-0.19 install
ENDOFFILE
chmod a+x 1434987998759.sh
sudo ./1434987998759.sh
sudo rm -rf 1434987998759.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libatasmart=>`date`" | sudo tee -a $INSTALLED_LIST