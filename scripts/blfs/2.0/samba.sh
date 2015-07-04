#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python2
#DEP:libxslt


cd $SOURCE_DIR

wget -nc https://download.samba.org/pub/samba/stable/samba-4.1.16.tar.gz


TARBALL=samba-4.1.16.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed "s:systemd-daemon:systemd:g" -i wscript lib/util/wscript_build

./configure                             \
    --prefix=/usr                       \
    --sysconfdir=/etc                   \
    --localstatedir=/var                \
    --with-piddir=/run/samba            \
    --with-pammodulesdir=/lib/security  \
    --enable-fhs                        \
    --enable-nss-wrapper                &&

make

sed -i "/samba3.blackbox.failure.failure/i \^samba3.raw.eas" selftest/knownfail

cat > 1434987998782.sh << "ENDOFFILE"
make install &&

mv -v /usr/lib/libnss_win{s,bind}.so* /lib                       &&
ln -sfv ../../lib/libnss_winbind.so.2 /usr/lib/libnss_winbind.so &&
ln -sfv ../../lib/libnss_wins.so.2    /usr/lib/libnss_wins.so    &&

install -v -m644  examples/smb.conf.default /etc/samba &&

install -v -dm755 /etc/openldap/schema                 &&

install -v -m644  examples/LDAP/README                 \
                  /etc/openldap/schema/README.LDAP     &&
                    
install -v -m644  examples/LDAP/samba*                 \
                  /etc/openldap/schema                 &&
                    
install -v -m755  examples/LDAP/{get*,ol*}             \
                  /etc/openldap/schema                 &&

install -v -dm755 /usr/share/doc/samba-4.1.16          &&

install -v -m644  lib/ntdb/doc/design.pdf \
                  /usr/share/doc/samba-4.1.16
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
ln -sfv /usr/bin/smbspool /usr/lib/cups/backend/smb
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"

ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"

ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"

ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-samba
cd ..
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-winbindd
cd ..
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
systemctl stop smbd &&
systemctl disable smbd &&
systemctl enable smbd.socket &&
systemctl start smbd.socket
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "samba=>`date`" | sudo tee -a $INSTALLED_LIST