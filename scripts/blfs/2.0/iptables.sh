#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.netfilter.org/projects/iptables/files/iptables-1.4.21.tar.bz2
wget -nc ftp://ftp.netfilter.org/pub/iptables/iptables-1.4.21.tar.bz2


TARBALL=iptables-1.4.21.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr   \
            --sbindir=/sbin \
            --enable-libipq \
            --with-xtlibdir=/lib/xtables &&
make

cat > 1434987998747.sh << "ENDOFFILE"
make install &&
ln -sfv ../../sbin/xtables-multi /usr/bin/iptables-xml &&

for file in ip4tc ip6tc ipq iptc xtables
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done
ENDOFFILE
chmod a+x 1434987998747.sh
sudo ./1434987998747.sh
sudo rm -rf 1434987998747.sh

cat > 1434987998747.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-iptables
cd ..
ENDOFFILE
chmod a+x 1434987998747.sh
sudo ./1434987998747.sh
sudo rm -rf 1434987998747.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "iptables=>`date`" | sudo tee -a $INSTALLED_LIST