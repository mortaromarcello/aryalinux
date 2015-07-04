#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gnutls
#DEP:gtk3
#DEP:libgcrypt
#DEP:gobject-introspection
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.5/gtk-vnc-0.5.4.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.5/gtk-vnc-0.5.4.tar.xz


TARBALL=gtk-vnc-0.5.4.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr  \
            --with-gtk=3.0 \
            --enable-vala  \
            --without-sasl &&
make

cat > 1434987998794.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gtk-vnc=>`date`" | sudo tee -a $INSTALLED_LIST