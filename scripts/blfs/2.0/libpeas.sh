#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gobject-introspection
#DEP:gtk3
#DEP:python-modules#pygobject3


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libpeas/1.12/libpeas-1.12.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libpeas/1.12/libpeas-1.12.1.tar.xz


TARBALL=libpeas-1.12.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998814.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998814.sh
sudo ./1434987998814.sh
sudo rm -rf 1434987998814.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libpeas=>`date`" | sudo tee -a $INSTALLED_LIST