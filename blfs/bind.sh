#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:bind-9.10.4-P:2

#OPT:libcap
#OPT:libxml2
#OPT:mitkrb
#OPT:openssl
#OPT:db
#OPT:mariadb
#OPT:openldap
#OPT:postgresql
#OPT:unixodbc
#OPT:perl-modules#perl-net-dns
#OPT:net-tools
#OPT:doxygen
#OPT:libxslt
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=ftp://ftp.isc.org/isc/bind9/9.10.4-P2/bind-9.10.4-P2.tar.gz

wget -nc ftp://ftp.isc.org/isc/bind9/9.10.4-P2/bind-9.10.4-P2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bind/bind-9.10.4-P2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bind/bind-9.10.4-P2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bind/bind-9.10.4-P2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bind/bind-9.10.4-P2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bind/bind-9.10.4-P2.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/bind-9.10.4-P2-use_iproute2-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/bind/bind-9.10.4-P2-use_iproute2-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../bind-9.10.4-P2-use_iproute2-1.patch


./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --localstatedir=/var    \
            --mandir=/usr/share/man \
            --enable-threads        \
            --with-libtool          \
            --disable-static        \
            --with-randomdev=/dev/urandom &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
bin/tests/system/ifconfig.sh up

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


make -k check



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
bin/tests/system/ifconfig.sh down

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/bind-9.10.4-P2/{arm,misc} &&
install -v -m644    doc/arm/*.html \
                    /usr/share/doc/bind-9.10.4-P2/arm &&
install -v -m644    doc/misc/{dnssec,ipv6,migrat*,options,rfc-compliance,roadmap,sdb} \
                    /usr/share/doc/bind-9.10.4-P2/misc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 20 named &&
useradd -c "BIND Owner" -g named -s /bin/false -u 20 named &&
install -d -m770 -o named -g named /srv/named

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd /srv/named &&
mkdir -p dev etc/namedb/{slave,pz} usr/lib/engines var/run/named &&
mknod /srv/named/dev/null c 1 3 &&
mknod /srv/named/dev/urandom c 1 9 &&
chmod 666 /srv/named/dev/{null,urandom} &&
cp /etc/localtime etc &&
touch /srv/named/managed-keys.bind &&
cp /usr/lib/engines/libgost.so usr/lib/engines &&
[ $(uname -m) = x86_64 ] && ln -sv lib usr/lib64

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rndc-confgen -r /dev/urandom -b 512 > /etc/rndc.conf &&
sed '/conf/d;/^#/!d;s:^# ::' /etc/rndc.conf > /srv/named/etc/named.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /srv/named/etc/named.conf << "EOF"
options {
 directory "/etc/namedb";
 pid-file "/var/run/named.pid";
 statistics-file "/var/run/named.stats";
};
zone "." {
 type hint;
 file "root.hints";
};
zone "0.0.127.in-addr.arpa" {
 type master;
 file "pz/127.0.0";
};
// Bind 9 now logs by default through syslog (except debug).
// These are the default logging rules.
logging {
 category default { default_syslog; default_debug; };
 category unmatched { null; };
 channel default_syslog {
 syslog daemon; // send to syslog's daemon
 // facility
 severity info; // only send priority info
 // and higher
 };
 channel default_debug {
 file "named.run"; // write to named.run in
 // the working directory
 // Note: stderr is used instead
 // of "named.run"
 // if the server is started
 // with the '-f' option.
 severity dynamic; // log at the server's
 // current debug level
 };
 channel default_stderr {
 stderr; // writes to stderr
 severity info; // only send priority info
 // and higher
 };
 channel null {
 null; // toss anything sent to
 // this channel
 };
};
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /srv/named/etc/namedb/pz/127.0.0 << "EOF"
$TTL 3D
@ IN SOA ns.local.domain. hostmaster.local.domain. (
 1 ; Serial
 8H ; Refresh
 2H ; Retry
 4W ; Expire
 1D) ; Minimum TTL
 NS ns.local.domain.
1 PTR localhost.
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /srv/named/etc/namedb/root.hints << "EOF"
. 6D IN NS A.ROOT-SERVERS.NET.
. 6D IN NS B.ROOT-SERVERS.NET.
. 6D IN NS C.ROOT-SERVERS.NET.
. 6D IN NS D.ROOT-SERVERS.NET.
. 6D IN NS E.ROOT-SERVERS.NET.
. 6D IN NS F.ROOT-SERVERS.NET.
. 6D IN NS G.ROOT-SERVERS.NET.
. 6D IN NS H.ROOT-SERVERS.NET.
. 6D IN NS I.ROOT-SERVERS.NET.
. 6D IN NS J.ROOT-SERVERS.NET.
. 6D IN NS K.ROOT-SERVERS.NET.
. 6D IN NS L.ROOT-SERVERS.NET.
. 6D IN NS M.ROOT-SERVERS.NET.
A.ROOT-SERVERS.NET. 6D IN A 198.41.0.4
B.ROOT-SERVERS.NET. 6D IN A 192.228.79.201
C.ROOT-SERVERS.NET. 6D IN A 192.33.4.12
D.ROOT-SERVERS.NET. 6D IN A 199.7.91.13
E.ROOT-SERVERS.NET. 6D IN A 192.203.230.10
F.ROOT-SERVERS.NET. 6D IN A 192.5.5.241
G.ROOT-SERVERS.NET. 6D IN A 192.112.36.4
H.ROOT-SERVERS.NET. 6D IN A 128.63.2.53
I.ROOT-SERVERS.NET. 6D IN A 192.36.148.17
J.ROOT-SERVERS.NET. 6D IN A 192.58.128.30
K.ROOT-SERVERS.NET. 6D IN A 193.0.14.129
L.ROOT-SERVERS.NET. 6D IN A 199.7.83.42
M.ROOT-SERVERS.NET. 6D IN A 202.12.27.33
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp /etc/resolv.conf /etc/resolv.conf.bak &&
cat > /etc/resolv.conf << "EOF"
search <em class="replaceable"><code><yourdomain.com></em>
nameserver 127.0.0.1
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chown -R named:named /srv/named

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.08/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-bind

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl start named

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


dig -x 127.0.0.1


dig www.linuxfromscratch.org &&
dig www.linuxfromscratch.org


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "bind=>`date`" | sudo tee -a $INSTALLED_LIST

