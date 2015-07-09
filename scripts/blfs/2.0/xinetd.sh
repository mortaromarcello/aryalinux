#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/xinetd-2.3.15.tar.gz


TARBALL=xinetd-2.3.15.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i -e "s/exec_server/child_process/" xinetd/builtins.c        &&
sed -i -e "/register unsigned count/s/register//" xinetd/itox.c  &&
./configure --prefix=/usr --mandir=/usr/share/man --with-loadavg &&
make

cat > 1434987998788.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
cat > /etc/xinetd.conf << "EOF"
# Begin /etc/xinetd
# Configuration file for xinetd

defaults
{
 instances = 60
 log_type = SYSLOG daemon
 log_on_success = HOST PID USERID
 log_on_failure = HOST USERID
 cps = 25 30
}

# All service files are stored in the /etc/xinetd.d directory

includedir /etc/xinetd.d

# End /etc/xinetd
EOF
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
install -v -d -m755 /etc/xinetd.d &&

cat > /etc/xinetd.d/systat << "EOF" &&
# Begin /etc/xinetd.d/systat

service systat
{
 disable = yes
 socket_type = stream
 wait = no
 user = nobody
 server = /bin/ps
 server_args = -auwwx
 only_from = 128.138.209.0
 log_on_success = HOST
}

# End /etc/xinetd.d/systat
EOF

cat > /etc/xinetd.d/echo << "EOF" &&
# Begin /etc/xinetd.d/echo

service echo
{
 disable = yes
 type = INTERNAL
 id = echo-stream
 socket_type = stream
 protocol = tcp
 user = root
 wait = no
}

service echo
{
 disable = yes
 type = INTERNAL
 id = echo-dgram
 socket_type = dgram
 protocol = udp
 user = root
 wait = yes
}

# End /etc/xinetd.d/echo
EOF

cat > /etc/xinetd.d/chargen << "EOF" &&
# Begin /etc/xinetd.d/chargen

service chargen
{
 disable = yes
 type = INTERNAL
 id = chargen-stream
 socket_type = stream
 protocol = tcp
 user = root
 wait = no
}

service chargen
{
 disable = yes
 type = INTERNAL
 id = chargen-dgram
 socket_type = dgram
 protocol = udp
 user = root
 wait = yes
}

# End /etc/xinetd.d/chargen
EOF

cat > /etc/xinetd.d/daytime << "EOF" &&
# Begin /etc/xinetd.d/daytime

service daytime
{
 disable = yes
 type = INTERNAL
 id = daytime-stream
 socket_type = stream
 protocol = tcp
 user = root
 wait = no
}

service daytime
{
 disable = yes
 type = INTERNAL
 id = daytime-dgram
 socket_type = dgram
 protocol = udp
 user = root
 wait = yes
}

# End /etc/xinetd.d/daytime
EOF

cat > /etc/xinetd.d/time << "EOF"
# Begin /etc/xinetd.d/time

service time
{
 disable = yes
 type = INTERNAL
 id = time-stream
 socket_type = stream
 protocol = tcp
 user = root
 wait = no
}

service time
{
 disable = yes
 type = INTERNAL
 id = time-dgram
 socket_type = dgram
 protocol = udp
 user = root
 wait = yes
}

# End /etc/xinetd.d/time
EOF
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-xinetd
cd ..
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh

cat > 1434987998788.sh << "ENDOFFILE"
systemctl start xinetd
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xinetd=>`date`" | sudo tee -a $INSTALLED_LIST