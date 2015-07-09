#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p1.tar.gz


TARBALL=ntp-4.2.8p1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998781.sh << "ENDOFFILE"
groupadd -g 87 ntp &&
useradd -c "Network Time Protocol" -d /var/lib/ntp -u 87 \
        -g ntp -s /bin/false ntp
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

./configure --prefix=/usr      \
            --bindir=/usr/sbin \
            --sysconfdir=/etc  \
            --enable-linuxcaps \
            --with-lineeditlibs=readline \
            --docdir=/usr/share/doc/ntp-4.2.8p1 &&
make

cat > 1434987998781.sh << "ENDOFFILE"
make install &&
install -v -dm755 -o ntp -g ntp /var/lib/ntp
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
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
EOF
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
cat >> /etc/ntp.conf << "EOF"
# Security session
restrict default limited kod nomodify notrap nopeer noquery
restrict -6 default limited kod nomodify notrap nopeer noquery

restrict 127.0.0.1
restrict ::1
EOF
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-ntpd
cd ..
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ntp=>`date`" | sudo tee -a $INSTALLED_LIST