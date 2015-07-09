#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gnome-desktop
#DEP:itstool
#DEP:libpeas
#DEP:shared-mime-info
#DEP:gobject-introspection
#DEP:librsvg


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/eog/3.14/eog-3.14.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/eog/3.14/eog-3.14.3.tar.xz


TARBALL=eog-3.14.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998819.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998819.sh
sudo ./1434987998819.sh
sudo rm -rf 1434987998819.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "eog=>`date`" | sudo tee -a $INSTALLED_LIST