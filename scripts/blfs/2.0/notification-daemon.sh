#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:libcanberra


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.14/notification-daemon-3.14.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.14/notification-daemon-3.14.1.tar.xz


TARBALL=notification-daemon-3.14.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998822.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998822.sh
sudo ./1434987998822.sh
sudo rm -rf 1434987998822.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "notification-daemon=>`date`" | sudo tee -a $INSTALLED_LIST