#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libusb
#DEP:gobject-introspection
#DEP:vala


cd $SOURCE_DIR

wget -nc http://people.freedesktop.org/~hughsient/releases/libgusb-0.2.4.tar.xz


TARBALL=libgusb-0.2.4.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998761.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998761.sh
sudo ./1434987998761.sh
sudo rm -rf 1434987998761.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libgusb=>`date`" | sudo tee -a $INSTALLED_LIST