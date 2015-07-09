#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:notification-daemon
#DEP:xfce4-notifyd


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libnotify/0.7/libnotify-0.7.6.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libnotify/0.7/libnotify-0.7.6.tar.xz


TARBALL=libnotify-0.7.6.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998795.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libnotify=>`date`" | sudo tee -a $INSTALLED_LIST