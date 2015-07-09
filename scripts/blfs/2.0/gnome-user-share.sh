#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:itstool
#DEP:libcanberra
#DEP:libnotify
#DEP:gnome-bluetooth
#DEP:nautilus


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-user-share/3.14/gnome-user-share-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-user-share/3.14/gnome-user-share-3.14.2.tar.xz


TARBALL=gnome-user-share-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr                \
            --sysconfdir=/etc            \
            --with-httpd=/usr/sbin/httpd \
            --with-modules-path=/usr/lib/httpd/modules &&
make

cat > 1434987998821.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998821.sh
sudo ./1434987998821.sh
sudo rm -rf 1434987998821.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-user-share=>`date`" | sudo tee -a $INSTALLED_LIST