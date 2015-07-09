#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:libxml2
#DEP:gobject-introspection
#DEP:grilo-plugins
#DEP:gtk3
#DEP:libsoup
#DEP:totem-pl-parser
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/grilo/0.2/grilo-0.2.12.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/grilo/0.2/grilo-0.2.12.tar.xz


TARBALL=grilo-0.2.12.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --libdir=/usr/lib \
            --disable-static &&
make

cat > 1434987998832.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998832.sh
sudo ./1434987998832.sh
sudo rm -rf 1434987998832.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "grilo=>`date`" | sudo tee -a $INSTALLED_LIST