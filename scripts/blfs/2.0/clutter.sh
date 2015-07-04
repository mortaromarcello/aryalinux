#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:atk
#DEP:cogl
#DEP:json-glib
#DEP:gobject-introspection
#DEP:libinput
#DEP:libxkbcommon
#DEP:systemd
#DEP:wayland


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter/1.20/clutter-1.20.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter/1.20/clutter-1.20.0.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/clutter-1.20.0-libinput_fixes-1.patch


TARBALL=clutter-1.20.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../clutter-1.20.0-libinput_fixes-1.patch &&
./configure --prefix=/usr               \
            --sysconfdir=/etc           \
            --enable-egl-backend        \
            --enable-evdev-input        \
            --enable-wayland-backend    \
            --enable-wayland-compositor &&
make

cat > 1434987998793.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "clutter=>`date`" | sudo tee -a $INSTALLED_LIST