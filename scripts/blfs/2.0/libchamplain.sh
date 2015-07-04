#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clutter
#DEP:gtk3
#DEP:libsoup
#DEP:clutter-gtk
#DEP:gobject-introspection
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.9.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.9.tar.xz


TARBALL=libchamplain-0.12.9.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --enable-vala    \
            --disable-static &&
make

cat > 1434987998814.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998814.sh
sudo ./1434987998814.sh
sudo rm -rf 1434987998814.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libchamplain=>`date`" | sudo tee -a $INSTALLED_LIST