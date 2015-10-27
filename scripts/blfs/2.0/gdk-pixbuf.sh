#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:libjpeg
#DEP:libpng
#DEP:libtiff
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.31/gdk-pixbuf-2.31.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.31/gdk-pixbuf-2.31.1.tar.xz


TARBALL=gdk-pixbuf-2.31.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-x11 &&
make

cat > 1434987998793.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh

cat > 1434987998793.sh << "ENDOFFILE"
gdk-pixbuf-query-loaders --update-cache
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gdk-pixbuf=>`date`" | sudo tee -a $INSTALLED_LIST