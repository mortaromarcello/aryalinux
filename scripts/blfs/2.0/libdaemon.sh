#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz


TARBALL=libdaemon-0.14.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998759.sh << "ENDOFFILE"
make docdir=/usr/share/doc/libdaemon-0.14 install
ENDOFFILE
chmod a+x 1434987998759.sh
sudo ./1434987998759.sh
sudo rm -rf 1434987998759.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libdaemon=>`date`" | sudo tee -a $INSTALLED_LIST