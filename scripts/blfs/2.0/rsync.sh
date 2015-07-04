#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:popt


cd $SOURCE_DIR

wget -nc https://download.samba.org/pub/rsync/src/rsync-3.1.1.tar.gz


TARBALL=rsync-3.1.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998782.sh << "ENDOFFILE"
groupadd -g 48 rsyncd &&
useradd -c "rsyncd Daemon" -d /home/rsync -g rsyncd \
    -s /bin/false -u 48 rsyncd
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

./configure --prefix=/usr --without-included-zlib &&
make

cat > 1434987998782.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
install -v -m755 -d          /usr/share/doc/rsync-3.1.1/api &&
install -v -m644 dox/html/*  /usr/share/doc/rsync-3.1.1/api
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
cat > /etc/rsyncd.conf << "EOF"
# This is a basic rsync configuration file
# It exports a single module without user authentication.

motd file = /home/rsync/welcome.msg
use chroot = yes

[localhost]
 path = /home/rsync
 comment = Default rsync module
 read only = yes
 list = yes
 uid = rsyncd
 gid = rsyncd

EOF
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-rsyncd
cd ..
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
systemctl stop rsyncd &&
systemctl disable rsyncd &&
systemctl enable rsyncd.socket &&
systemctl start rsyncd.socket
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "rsync=>`date`" | sudo tee -a $INSTALLED_LIST