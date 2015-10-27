#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:nasm


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.4.0.tar.gz


TARBALL=libjpeg-turbo-1.4.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i -e '/^docdir/     s:$:/libjpeg-turbo-1.4.0:' \
       -e '/^exampledir/ s:$:/libjpeg-turbo-1.4.0:' Makefile.in &&

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-jpeg8            \
            --disable-static &&
make

cat > 1434987998766.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998766.sh
sudo ./1434987998766.sh
sudo rm -rf 1434987998766.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libjpeg=>`date`" | sudo tee -a $INSTALLED_LIST