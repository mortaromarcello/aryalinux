#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:ptlib


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.10.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/opal-3.10.10-ffmpeg2-1.patch


TARBALL=opal-3.10.10.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../opal-3.10.10-ffmpeg2-1.patch &&

./configure --prefix=/usr &&
make

cat > 1434987998836.sh << "ENDOFFILE"
make install &&
chmod -v 644 /usr/lib/libopal_s.a
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "opal=>`date`" | sudo tee -a $INSTALLED_LIST