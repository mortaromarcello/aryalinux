#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl


cd $SOURCE_DIR

wget -nc http://www.unbound.net/downloads/unbound-1.5.1.tar.gz


TARBALL=unbound-1.5.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998788.sh << "ENDOFFILE"
groupadd -g 88 unbound &&
useradd -c "Unbound DNS resolver" -d /var/lib/unbound -u 88 \
        -g unbound -s /bin/false unbound
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --with-pidfile=/run/unbound.pid &&
make

make doc

cat > 1434987998788.sh << "ENDOFFILE"
make install &&
mv -v /usr/sbin/unbound-host /usr/bin/
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
install -v -m755 -d /usr/share/doc/unbound-1.5.1 &&
install -v -m644 doc/html/* /usr/share/doc/unbound-1.5.1
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
echo "nameserver 127.0.0.1" > /etc/resolv.conf
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
sed -i '/request /i\supersede domain-name-servers 127.0.0.1;' \
       /etc/dhcp/dhclient.conf
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
unbound-anchor
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-unbound
cd ..
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "unbound=>`date`" | sudo tee -a $INSTALLED_LIST