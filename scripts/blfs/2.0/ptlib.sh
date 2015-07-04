#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-lib
#DEP:openssl


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.10.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.10.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/ptlib-2.10.10-bison_fixes-1.patch


TARBALL=ptlib-2.10.10.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../ptlib-2.10.10-bison_fixes-1.patch &&

./configure --prefix=/usr &&
make

cat > 1434987998764.sh << "ENDOFFILE"
make install &&
chmod -v 755 /usr/lib/libpt.so.2.10.10
ENDOFFILE
chmod a+x 1434987998764.sh
sudo ./1434987998764.sh
sudo rm -rf 1434987998764.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ptlib=>`date`" | sudo tee -a $INSTALLED_LIST