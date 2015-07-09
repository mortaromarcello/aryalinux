#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://roy.marples.name/downloads/dhcpcd/dhcpcd-6.7.1.tar.bz2
wget -nc ftp://roy.marples.name/pub/dhcpcd/dhcpcd-6.7.1.tar.bz2


TARBALL=dhcpcd-6.7.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:BSD_SOURCE:DEFAULT_SOURCE:g" configure

./configure --libexecdir=/lib/dhcpcd \
            --dbdir=/var/tmp         &&
make

cat > 1434987998780.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-dhcpcd
cd ..
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "dhcpcd=>`date`" | sudo tee -a $INSTALLED_LIST