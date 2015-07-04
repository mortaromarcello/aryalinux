#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2
wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2


TARBALL=gtk-engines-2.20.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998794.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gtk-engines=>`date`" | sudo tee -a $INSTALLED_LIST