#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gmime
#DEP:libsoup
#DEP:gobject-introspection
#DEP:libarchive
#DEP:libgcrypt


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.10/totem-pl-parser-3.10.4.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.10/totem-pl-parser-3.10.4.tar.xz


TARBALL=totem-pl-parser-3.10.4.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998812.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998812.sh
sudo ./1434987998812.sh
sudo rm -rf 1434987998812.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "totem-pl-parser=>`date`" | sudo tee -a $INSTALLED_LIST