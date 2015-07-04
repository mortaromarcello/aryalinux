#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/faac/faac-1.28.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/faac-1.28-glibc_fixes-1.patch


TARBALL=faac-1.28.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../faac-1.28-glibc_fixes-1.patch &&
sed -i -e '/obj-type/d' -e '/Long Term/d' frontend/main.c &&
./configure --prefix=/usr --disable-static &&
make

cat > 1434987998832.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998832.sh
sudo ./1434987998832.sh
sudo rm -rf 1434987998832.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "faac=>`date`" | sudo tee -a $INSTALLED_LIST