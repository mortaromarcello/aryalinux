#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cairo
#DEP:harfbuzz
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pango/1.36/pango-1.36.8.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pango/1.36/pango-1.36.8.tar.xz


TARBALL=pango-1.36.8.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998795.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
pango-querymodules --update-cache
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "pango=>`date`" | sudo tee -a $INSTALLED_LIST