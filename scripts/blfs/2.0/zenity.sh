#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:itstool
#DEP:libnotify


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/zenity/3.14/zenity-3.14.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/zenity/3.14/zenity-3.14.0.tar.xz


TARBALL=zenity-3.14.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998817.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998817.sh
sudo ./1434987998817.sh
sudo rm -rf 1434987998817.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "zenity=>`date`" | sudo tee -a $INSTALLED_LIST