#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:icu
#DEP:libpng
#DEP:sqlite
#DEP:vala
#DEP:gtk3
#DEP:gobject-introspection
#DEP:gst10-plugins-base
#DEP:libgee
#DEP:libgsf
#DEP:libjpeg
#DEP:libmediaart
#DEP:libtiff
#DEP:libxml2
#DEP:nautilus
#DEP:networkmanager
#DEP:poppler
#DEP:totem-pl-parser
#DEP:upower


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/tracker/1.2/tracker-1.2.5.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/tracker/1.2/tracker-1.2.5.tar.xz


TARBALL=tracker-1.2.5.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --disable-static          \
            --disable-unit-tests      \
            --disable-miner-evolution \
            --disable-miner-firefox   \
            --disable-miner-thunderbird &&
make

cat > 1434987998812.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998812.sh
sudo ./1434987998812.sh
sudo rm -rf 1434987998812.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "tracker=>`date`" | sudo tee -a $INSTALLED_LIST