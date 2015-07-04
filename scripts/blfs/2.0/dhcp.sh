#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.isc.org/isc/dhcp/4.3.1/dhcp-4.3.1.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/dhcp-4.3.1-client_script-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/dhcp-4.3.1-missing_ipv6-1.patch


TARBALL=dhcp-4.3.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../dhcp-4.3.1-missing_ipv6-1.patch

patch -Np1 -i ../dhcp-4.3.1-client_script-1.patch &&
CFLAGS="-D_PATH_DHCLIENT_SCRIPT='\"/sbin/dhclient-script\"'         \
        -D_PATH_DHCPD_CONF='\"/etc/dhcp/dhcpd.conf\"'               \
        -D_PATH_DHCLIENT_CONF='\"/etc/dhcp/dhclient.conf\"'"        \
./configure --prefix=/usr                                           \
            --sysconfdir=/etc/dhcp                                  \
            --localstatedir=/var                                    \
            --with-srv-lease-file=/var/lib/dhcpd/dhcpd.leases       \
            --with-srv6-lease-file=/var/lib/dhcpd/dhcpd6.leases     \
            --with-cli-lease-file=/var/lib/dhclient/dhclient.leases \
            --with-cli6-lease-file=/var/lib/dhclient/dhclient6.leases &&
make

cat > 1434987998781.sh << "ENDOFFILE"
make -C client install         &&
mv -v /usr/sbin/dhclient /sbin &&
install -v -m755 client/scripts/linux /sbin/dhclient-script
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
make -C server install
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
make install                   &&
mv -v /usr/sbin/dhclient /sbin &&
install -v -m755 client/scripts/linux /sbin/dhclient-script
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
cat > /etc/dhcp/dhclient.conf << "EOF"
# Begin /etc/dhcp/dhclient.conf
#
# Basic dhclient.conf(5)

#prepend domain-name-servers 127.0.0.1;
request subnet-mask, broadcast-address, time-offset, routers,
 domain-name, domain-name-servers, domain-search, host-name,
 netbios-name-servers, netbios-scope, interface-mtu,
 ntp-servers;
require subnet-mask, domain-name-servers;
#timeout 60;
#retry 60;
#reboot 10;
#select-timeout 5;
#initial-interval 2;

# End /etc/dhcp/dhclient.conf
EOF
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
install -v -dm 755 /var/lib/dhclient
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-dhclient
cd ..
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
systemctl start dhclient@<em class="replaceable"><code>eth0</em>
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
systemctl enable dhclient@<em class="replaceable"><code>eth0</em>
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
cat > /etc/dhcp/dhcpd.conf << "EOF"
# Begin /etc/dhcp/dhcpd.conf
#
# Example dhcpd.conf(5)

# Use this to enble / disable dynamic dns updates globally.
ddns-update-style none;

# option definitions common to all supported networks...
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

# This is a very basic subnet declaration.
subnet 10.254.239.0 netmask 255.255.255.224 {
 range 10.254.239.10 10.254.239.20;
 option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
}

# End /etc/dhcp/dhcpd.conf
EOF
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
install -v -dm 755 /var/lib/dhcpd
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-dhcpd
cd ..
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "dhcp=>`date`" | sudo tee -a $INSTALLED_LIST