#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:pcre


cd $SOURCE_DIR

wget -nc http://ftp.exim.org/pub/exim/exim4/exim-4.85.tar.bz2
wget -nc ftp://ftp.exim.org/pub/exim/exim4/exim-4.85.tar.bz2


TARBALL=exim-4.85.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998787.sh << "ENDOFFILE"
groupadd -g 31 exim &&
useradd -d /dev/null -c "Exim Daemon" -g exim -s /bin/false -u 31 exim
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

sed -e 's,^BIN_DIR.*$,BIN_DIRECTORY=/usr/sbin,' \
    -e 's,^CONF.*$,CONFIGURE_FILE=/etc/exim.conf,' \
    -e 's,^EXIM_USER.*$,EXIM_USER=exim,' \
    -e 's,^EXIM_MONITOR,#EXIM_MONITOR,' src/EDITME > Local/Makefile &&
printf "USE_GDBM = yes\nDBMLIB = -lgdbm\n" >> Local/Makefile &&
make

cat > 1434987998787.sh << "ENDOFFILE"
make install &&
install -v -m644 doc/exim.8 /usr/share/man/man8 &&
install -v -d -m755 /usr/share/doc/exim-4.85 &&
install -v -m644 doc/* /usr/share/doc/exim-4.85 &&
ln -sfv exim /usr/sbin/sendmail
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
cat >> /etc/aliases << "EOF"
postmaster: root
MAILER-DAEMON: root
EOF
exim -v -bi &&
/usr/sbin/exim -bd -q15m
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-exim
cd ..
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "exim=>`date`" | sudo tee -a $INSTALLED_LIST