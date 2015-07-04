#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gnome-online-accounts
#DEP:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libzapojit/0.0/libzapojit-0.0.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libzapojit/0.0/libzapojit-0.0.3.tar.xz


TARBALL=libzapojit-0.0.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libzapojit-0.0.3 &&
make

cat > 1434987998815.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998815.sh
sudo ./1434987998815.sh
sudo rm -rf 1434987998815.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libzapojit=>`date`" | sudo tee -a $INSTALLED_LIST