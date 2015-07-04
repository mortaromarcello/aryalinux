#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/faac/faad2-2.7.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/faad2-2.7-mp4ff-1.patch


TARBALL=faad2-2.7.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../faad2-2.7-mp4ff-1.patch &&
sed -i "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" configure.in &&
sed -i "s:man_MANS:man1_MANS:g" frontend/Makefile.am &&
autoreconf -fi &&
./configure --prefix=/usr --disable-static &&
make

./frontend/faad -o sample.wav ../sample.aac

aplay sample.wav

cat > 1434987998832.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998832.sh
sudo ./1434987998832.sh
sudo rm -rf 1434987998832.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "faad2=>`date`" | sudo tee -a $INSTALLED_LIST