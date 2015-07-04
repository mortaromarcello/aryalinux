#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:libxml2
#DEP:gobject-introspection
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/vte/0.38/vte-0.38.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vte/0.38/vte-0.38.3.tar.xz


TARBALL=vte-0.38.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make

cat > 1434987998813.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998813.sh
sudo ./1434987998813.sh
sudo rm -rf 1434987998813.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "vte=>`date`" | sudo tee -a $INSTALLED_LIST