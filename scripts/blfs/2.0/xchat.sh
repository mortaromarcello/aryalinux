#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:gtk2


cd $SOURCE_DIR

wget -nc http://www.xchat.org/files/source/2.8/xchat-2.8.8.tar.bz2
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/xchat-2.8.8.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xchat-2.8.8-glib-2.31-1.patch


TARBALL=xchat-2.8.8.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../xchat-2.8.8-glib-2.31-1.patch &&

LIBS+="-lgmodule-2.0"         \
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-shm &&
make

cat > 1434987998831.sh << "ENDOFFILE"
make install &&
install -v -dm755 /usr/share/doc/xchat-2.8.8 &&
install -v -m644  README faq.html \
                  /usr/share/doc/xchat-2.8.8
ENDOFFILE
chmod a+x 1434987998831.sh
sudo ./1434987998831.sh
sudo rm -rf 1434987998831.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xchat=>`date`" | sudo tee -a $INSTALLED_LIST