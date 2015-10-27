#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:libxml2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/libcroco-0.6.8.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/libcroco-0.6.8.tar.xz


TARBALL=libcroco-0.6.8.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998759.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998759.sh
sudo ./1434987998759.sh
sudo rm -rf 1434987998759.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libcroco=>`date`" | sudo tee -a $INSTALLED_LIST