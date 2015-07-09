#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.116.tgz


TARBALL=LVM2.2.02.116.tgz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr       \
            --exec-prefix=      \
            --with-confdir=/etc \
            --enable-applib     \
            --enable-cmdlib     \
            --enable-pkgconfig  \
            --enable-udev_sync  &&
make

cat > 1434987998752.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998752.sh
sudo ./1434987998752.sh
sudo rm -rf 1434987998752.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lvm2=>`date`" | sudo tee -a $INSTALLED_LIST