#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl
#DEP:db


cd $SOURCE_DIR

wget -nc ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/cyrus-sasl-2.1.26-fixes-3.patch


TARBALL=cyrus-sasl-2.1.26.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../cyrus-sasl-2.1.26-fixes-3.patch &&
autoreconf -fi &&
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --enable-auth-sasldb \
            --with-dbpath=/var/lib/sasl/sasldb2 \
            --with-saslauthd=/var/run/saslauthd &&
make

cat > 1434987998746.sh << "ENDOFFILE"
make install &&
install -v -dm755 /usr/share/doc/cyrus-sasl-2.1.26 &&
install -v -m644  doc/{*.{html,txt,fig},ONEWS,TODO} \
    saslauthd/LDAP_SASLAUTHD /usr/share/doc/cyrus-sasl-2.1.26 &&
install -v -dm700 /var/lib/sasl
ENDOFFILE
chmod a+x 1434987998746.sh
sudo ./1434987998746.sh
sudo rm -rf 1434987998746.sh

cat > 1434987998746.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-saslauthd
cd ..
ENDOFFILE
chmod a+x 1434987998746.sh
sudo ./1434987998746.sh
sudo rm -rf 1434987998746.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cyrus-sasl=>`date`" | sudo tee -a $INSTALLED_LIST