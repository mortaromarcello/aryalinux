#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gnome-settings-daemon
#DEP:libdvdread
#DEP:libpwquality
#DEP:libsecret
#DEP:udisks2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-disk-utility/3.14/gnome-disk-utility-3.14.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-disk-utility/3.14/gnome-disk-utility-3.14.0.tar.xz


TARBALL=gnome-disk-utility-3.14.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998820.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998820.sh
sudo ./1434987998820.sh
sudo rm -rf 1434987998820.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-disk-utility=>`date`" | sudo tee -a $INSTALLED_LIST