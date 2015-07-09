#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:grilo
#DEP:libgcrypt
#DEP:sqlite
#DEP:libsoup
#DEP:gobject-introspection
#DEP:totem-pl-parser


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/grilo-plugins/0.2/grilo-plugins-0.2.14.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/grilo-plugins/0.2/grilo-plugins-0.2.14.tar.xz


TARBALL=grilo-plugins-0.2.14.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998832.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998832.sh
sudo ./1434987998832.sh
sudo rm -rf 1434987998832.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "grilo-plugins=>`date`" | sudo tee -a $INSTALLED_LIST