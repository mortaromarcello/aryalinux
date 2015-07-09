#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:enchant
#DEP:gsettings-desktop-schemas
#DEP:gtk3
#DEP:iso-codes
#DEP:libsoup


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkhtml/4.8/gtkhtml-4.8.5.tar.xz
wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkhtml/4.8/gtkhtml-4.8.5.tar.xz


TARBALL=gtkhtml-4.8.5.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998813.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998813.sh
sudo ./1434987998813.sh
sudo rm -rf 1434987998813.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gtkhtml=>`date`" | sudo tee -a $INSTALLED_LIST