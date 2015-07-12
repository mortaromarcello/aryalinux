#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gdk-pixbuf
#DEP:libcroco
#DEP:pango
#DEP:gtk3
#DEP:vala
#DEP:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/librsvg-2.40.7.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/librsvg-2.40.7.tar.xz


TARBALL=librsvg-2.40.7.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --enable-vala \
            --disable-static &&
make

cat > 1434987998767.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998767.sh
sudo ./1434987998767.sh
sudo rm -rf 1434987998767.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "librsvg=>`date`" | sudo tee -a $INSTALLED_LIST