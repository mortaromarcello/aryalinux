#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2
#DEP:dbus-glib


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/lxde/lxappearance-0.6.1.tar.xz


TARBALL=lxappearance-0.6.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-dbus     &&
make

cat > 1434987998826.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998826.sh
sudo ./1434987998826.sh
sudo rm -rf 1434987998826.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lxappearance=>`date`" | sudo tee -a $INSTALLED_LIST