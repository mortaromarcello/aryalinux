#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://sourceforge.net/projects/bridge/files/bridge/bridge-utils-1.5.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/bridge-utils-1.5-linux_3.8_fix-1.patch


TARBALL=bridge-utils-1.5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../bridge-utils-1.5-linux_3.8_fix-1.patch &&
autoconf -o configure configure.in                      &&
./configure --prefix=/usr                               &&
make

cat > 1434987998781.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "bridge-utils=>`date`" | sudo tee -a $INSTALLED_LIST