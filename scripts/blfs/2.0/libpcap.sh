#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.tcpdump.org/release/libpcap-1.6.2.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libpcap-1.6.2-enable_bluetooth-1.patch


TARBALL=libpcap-1.6.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../libpcap-1.6.2-enable_bluetooth-1.patch &&
./configure --prefix=/usr &&
make

sed -i '/INSTALL_DATA.*libpcap.a\|RANLIB.*libpcap.a/ s/^/#/' Makefile

cat > 1434987998784.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998784.sh
sudo ./1434987998784.sh
sudo rm -rf 1434987998784.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libpcap=>`date`" | sudo tee -a $INSTALLED_LIST