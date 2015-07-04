#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libjpeg
#DEP:lcms2


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/libmng/libmng-2.0.2.tar.xz


TARBALL=libmng-2.0.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "/jpeglib.h/i #include <stdio.h>" libmng_types.h &&

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998766.sh << "ENDOFFILE"
make install &&

install -v -dm755          /usr/share/doc/libmng-2.0.2 &&
install -v -m644 doc/*.txt /usr/share/doc/libmng-2.0.2
ENDOFFILE
chmod a+x 1434987998766.sh
sudo ./1434987998766.sh
sudo rm -rf 1434987998766.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libmng=>`date`" | sudo tee -a $INSTALLED_LIST