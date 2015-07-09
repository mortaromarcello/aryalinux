#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:gsettings-desktop-schemas
#DEP:python-modules#pygobject3


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.14/gnome-tweak-tool-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.14/gnome-tweak-tool-3.14.2.tar.xz


TARBALL=gnome-tweak-tool-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998821.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998821.sh
sudo ./1434987998821.sh
sudo rm -rf 1434987998821.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-tweak-tool=>`date`" | sudo tee -a $INSTALLED_LIST