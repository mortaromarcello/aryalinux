#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl
#DEP:libpciaccess
#DEP:pixman
#DEP:x7font
#DEP:xkeyboard-config
#DEP:libepoxy
#DEP:wayland
#DEP:systemd
#DEP:xcb-util-keysyms


cd $SOURCE_DIR

wget -nc http://xorg.freedesktop.org/archive/individual/xserver/xorg-server-1.17.1.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/xserver/xorg-server-1.17.1.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xorg-server-1.17.1-add_prime_support-1.patch


TARBALL=xorg-server-1.17.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../xorg-server-1.17.1-add_prime_support-1.patch

./configure $XORG_CONFIG                  \
           --with-xkb-output=/var/lib/xkb \
           --enable-glamor                \
           --enable-suid-wrapper          &&
make

cat > 1434987998790.sh << "ENDOFFILE"
make install &&
mkdir -pv /etc/X11/xorg.conf.d
ENDOFFILE
chmod a+x 1434987998790.sh
sudo ./1434987998790.sh
sudo rm -rf 1434987998790.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xorg-server=>`date`" | sudo tee -a $INSTALLED_LIST