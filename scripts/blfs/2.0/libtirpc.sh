#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/libtirpc/libtirpc-0.2.5.tar.bz2


TARBALL=libtirpc-0.2.5.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --disable-gssapi  &&
make

cat > 1434987998785.sh << "ENDOFFILE"
make install &&
mv -v /usr/lib/libtirpc.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libtirpc.so) /usr/lib/libtirpc.so
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libtirpc=>`date`" | sudo tee -a $INSTALLED_LIST