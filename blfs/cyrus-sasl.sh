#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:cyrus-sasl:2.1.26

#REQ:openssl
#REC:db
#OPT:linux-pam
#OPT:mitkrb
#OPT:mariadb
#OPT:openjdk
#OPT:openldap
#OPT:postgresql
#OPT:sqlite


cd $SOURCE_DIR

URL=ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz

wget -nc ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/cyrus-sasl/cyrus-sasl-2.1.26-fixes-3.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/cyrus-sasl-2.1.26-fixes-3.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../cyrus-sasl-2.1.26-fixes-3.patch &&
autoreconf -fi &&
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --enable-auth-sasldb \
            --with-dbpath=/var/lib/sasl/sasldb2 \
            --with-saslauthd=/var/run/saslauthd &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755 /usr/share/doc/cyrus-sasl-2.1.26 &&
install -v -m644  doc/{*.{html,txt,fig},ONEWS,TODO} \
    saslauthd/LDAP_SASLAUTHD /usr/share/doc/cyrus-sasl-2.1.26 &&
install -v -dm700 /var/lib/sasl

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.07/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-saslauthd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "cyrus-sasl=>`date`" | sudo tee -a $INSTALLED_LIST

