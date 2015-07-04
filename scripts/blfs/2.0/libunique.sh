#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libunique-1.1.6-upstream_fixes-1.patch


TARBALL=libunique-1.1.6.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../libunique-1.1.6-upstream_fixes-1.patch &&
autoreconf -fi &&

./configure --prefix=/usr  \
            --disable-dbus \
            --disable-static &&
make

cat > 1434987998826.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998826.sh
sudo ./1434987998826.sh
sudo rm -rf 1434987998826.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libunique=>`date`" | sudo tee -a $INSTALLED_LIST