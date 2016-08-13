#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:unbound:1.5.9

#REQ:openssl
#OPT:libevent
#OPT:nettle
#OPT:python2
#OPT:swig
#OPT:doxygen


cd $SOURCE_DIR

URL=http://www.unbound.net/downloads/unbound-1.5.9.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unbound/unbound-1.5.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unbound/unbound-1.5.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unbound/unbound-1.5.9.tar.gz || wget -nc http://www.unbound.net/downloads/unbound-1.5.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unbound/unbound-1.5.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unbound/unbound-1.5.9.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 88 unbound &&
useradd -c "Unbound DNS resolver" -d /var/lib/unbound -u 88 \
        -g unbound -s /bin/false unbound

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --with-pidfile=/run/unbound.pid &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v /usr/sbin/unbound-host /usr/bin/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "nameserver 127.0.0.1" > /etc/resolv.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/request /i\supersede domain-name-servers 127.0.0.1;' \
       /etc/dhcp/dhclient.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
unbound-anchor

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.08/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-unbound

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "unbound=>`date`" | sudo tee -a $INSTALLED_LIST

