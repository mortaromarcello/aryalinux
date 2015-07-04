#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz


TARBALL=a52dec-0.7.4.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --enable-shared \
            --disable-static \
            CFLAGS="-g -O2 $([ $(uname -m) = x86_64 ] && echo -fPIC)" &&
make

cat > 1434987998834.sh << "ENDOFFILE"
make install &&
cp liba52/a52_internal.h /usr/include/a52dec &&
install -v -Dm644 doc/liba52.txt \
    /usr/share/doc/liba52-0.7.4/liba52.txt
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "liba52=>`date`" | sudo tee -a $INSTALLED_LIST