#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:xorg-server


cd $SOURCE_DIR

wget -nc http://xorg.freedesktop.org/archive/individual/driver/xf86-input-vmmouse-13.0.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-vmmouse-13.0.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xf86-input-vmmouse-13.0.0-build_fix-1.patch


TARBALL=xf86-input-vmmouse-13.0.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../xf86-input-vmmouse-13.0.0-build_fix-1.patch &&
./configure $XORG_CONFIG               \
            --without-hal-callouts-dir \
            --without-hal-fdi-dir      \
            --with-udev-rules-dir=/lib/udev/rules.d &&
make

cat > 1434987998791.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998791.sh
sudo ./1434987998791.sh
sudo rm -rf 1434987998791.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "x7driver#xorg-vmmouse-driver=>`date`" | sudo tee -a $INSTALLED_LIST