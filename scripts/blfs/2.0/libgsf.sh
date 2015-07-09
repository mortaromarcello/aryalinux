#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:libxml2
#DEP:gdk-pixbuf


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.31.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.31.tar.xz


TARBALL=libgsf-1.14.31.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998760.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998760.sh
sudo ./1434987998760.sh
sudo rm -rf 1434987998760.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libgsf=>`date`" | sudo tee -a $INSTALLED_LIST