#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clutter
#DEP:gtk3
#DEP:libgee
#DEP:libxklavier
#DEP:python-modules#pygobject3
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.17.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.17.tar.xz


TARBALL=caribou-0.4.17.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --disable-gtk2-module \
            --disable-static &&
make

cat > 1434987998816.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998816.sh
sudo ./1434987998816.sh
sudo rm -rf 1434987998816.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "caribou=>`date`" | sudo tee -a $INSTALLED_LIST