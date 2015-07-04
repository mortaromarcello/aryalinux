#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cairo
#DEP:libinput
#DEP:libjpeg
#DEP:libxkbcommon
#DEP:mesalib
#DEP:mtdev
#DEP:wayland
#DEP:glu
#DEP:linux-pam
#DEP:pango
#DEP:systemd
#DEP:x7lib
#DEP:xorg-server


cd $SOURCE_DIR

wget -nc http://wayland.freedesktop.org/releases/weston-1.7.0.tar.xz


TARBALL=weston-1.7.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr   \
            --with-cairo=gl \
            --enable-demo-clients-install &&
make

cat > 1434987998774.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh

weston

weston-launch

weston-launch -- --backend=fbdev-backend.so


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "weston=>`date`" | sudo tee -a $INSTALLED_LIST