#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Unbound is a validating,br3ak recursive, and caching DNS resolver. It is designed as a set ofbr3ak modular components that incorporate modern features, such asbr3ak enhanced security (DNSSEC) validation, Internet Protocol Version 6br3ak (IPv6), and a client resolver library API as an integral part ofbr3ak the architecture.br3ak
#SECTION:server

whoami > /tmp/currentuser

#REQ:openssl
#OPT:libevent
#OPT:nettle
#OPT:python2
#OPT:swig
#OPT:doxygen


#VER:unbound:1.5.10


NAME="unbound"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://www.unbound.net/downloads/unbound-1.5.10.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unbound/unbound-1.5.10.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unbound/unbound-1.5.10.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unbound/unbound-1.5.10.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unbound/unbound-1.5.10.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unbound/unbound-1.5.10.tar.gz


URL=http://www.unbound.net/downloads/unbound-1.5.10.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-unbound

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
