#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:colord
#DEP:gtk3
#DEP:gobject-introspection
#DEP:vala


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/colord/releases/colord-gtk-0.1.26.tar.xz


TARBALL=colord-gtk-0.1.26.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --enable-vala    \
            --disable-static &&
make

cat > 1434987998793.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "colord-gtk=>`date`" | sudo tee -a $INSTALLED_LIST