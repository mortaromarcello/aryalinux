#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ntp-4.2.p:8

#REQ:wget
#REQ:general_which
#OPT:libcap
#OPT:libevent
#OPT:openssl


cd $SOURCE_DIR

URL=https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p8.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ntp/ntp-4.2.8p8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ntp/ntp-4.2.8p8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ntp/ntp-4.2.8p8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ntp/ntp-4.2.8p8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ntp/ntp-4.2.8p8.tar.gz || wget -nc https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p8.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 87 ntp &&
useradd -c "Network Time Protocol" -d /var/lib/ntp -u 87 \
        -g ntp -s /bin/false ntp

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr         \
            --bindir=/usr/sbin    \
            --sysconfdir=/etc     \
            --enable-linuxcaps    \
            --with-lineeditlibs=readline \
            --docdir=/usr/share/doc/ntp-4.2.8p8 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -o ntp -g ntp -d /var/lib/ntp

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/ntp.conf << "EOF"
# Asia
server 0.asia.pool.ntp.org
# Australia
server 0.oceania.pool.ntp.org
# Europe
server 0.europe.pool.ntp.org
# North America
server 0.north-america.pool.ntp.org
# South America
server 2.south-america.pool.ntp.org
driftfile /var/lib/ntp/ntp.drift
pidfile /var/run/ntpd.pid
leapfile /etc/ntp.leapseconds
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ntp.conf << "EOF"
# Security session
restrict default limited kod nomodify notrap nopeer noquery
restrict -6 default limited kod nomodify notrap nopeer noquery
restrict 127.0.0.1
restrict ::1
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.07/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
make install-ntpd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ntp=>`date`" | sudo tee -a $INSTALLED_LIST

