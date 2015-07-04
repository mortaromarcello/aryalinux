#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/project/haveged/haveged-1.9.1.tar.gz


TARBALL=haveged-1.9.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998746.sh << "ENDOFFILE"
make install &&
mkdir -pv    /usr/share/doc/haveged-1.9.1 &&
cp -v README /usr/share/doc/haveged-1.9.1
ENDOFFILE
chmod a+x 1434987998746.sh
sudo ./1434987998746.sh
sudo rm -rf 1434987998746.sh

cat > 1434987998746.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-haveged
cd ..
ENDOFFILE
chmod a+x 1434987998746.sh
sudo ./1434987998746.sh
sudo rm -rf 1434987998746.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "haveged=>`date`" | sudo tee -a $INSTALLED_LIST