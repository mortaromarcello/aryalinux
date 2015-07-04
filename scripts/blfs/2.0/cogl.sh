#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gdk-pixbuf
#DEP:mesalib
#DEP:pango
#DEP:gobject-introspection
#DEP:wayland


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/cogl/1.18/cogl-1.18.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cogl/1.18/cogl-1.18.2.tar.xz


TARBALL=cogl-1.18.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr                 \
            --enable-gles1                \
            --enable-gles2                \
            --enable-kms-egl-platform     \
            --enable-wayland-egl-platform \
            --enable-xlib-egl-platform    \
            --enable-wayland-egl-server   &&
make

cat > 1434987998793.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cogl=>`date`" | sudo tee -a $INSTALLED_LIST