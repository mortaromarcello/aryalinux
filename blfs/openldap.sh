#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The OpenLDAP package provides anbr3ak open source implementation of the Lightweight Directory Accessbr3ak Protocol.br3ak
#SECTION:server

whoami > /tmp/currentuser

#REC:cyrus-sasl
#REC:openssl
#OPT:icu
#OPT:pth
#OPT:unixodbc
#OPT:mariadb
#OPT:postgresql
#OPT:db


#VER:openldap:2.4.44


NAME="openldap"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openldap/openldap-2.4.44.tgz || wget -nc ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.44.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/openldap-2.4.44-consolidated-2.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/openldap/openldap-2.4.44-consolidated-2.patch


URL=ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.44.tgz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../openldap-2.4.44-consolidated-2.patch &&
autoconf &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --enable-dynamic  \
            --disable-debug   \
            --disable-slapd &&
make depend &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
tar xf $TARBALL
cd $DIRECTORY



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 83 ldap &&
useradd  -c "OpenLDAP Daemon Owner" \
         -d /var/lib/openldap -u 83 \
         -g ldap -s /bin/false ldap

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


patch -Np1 -i ../openldap-2.4.44-consolidated-2.patch &&
autoconf &&
./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --libexecdir=/usr/lib \
            --disable-static      \
            --disable-debug       \
            --with-tls=openssl    \
            --with-cyrus-sasl     \
            --enable-dynamic      \
            --enable-crypt        \
            --enable-spasswd      \
            --enable-slapd        \
            --enable-modules      \
            --enable-rlookups     \
            --enable-backends=mod \
            --disable-ndb         \
            --disable-sql         \
            --disable-shell       \
            --disable-bdb         \
            --disable-hdb         \
            --enable-overlays=mod &&
make depend &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm700 -o ldap -g ldap /var/lib/openldap     &&
install -v -dm700 -o ldap -g ldap /etc/openldap/slapd.d &&
chmod   -v    640     /etc/openldap/slapd.{conf,ldif}   &&
chown   -v  root:ldap /etc/openldap/slapd.{conf,ldif}   &&
install -v -dm755 /usr/share/doc/openldap-2.4.44 &&
cp      -vfr      doc/{drafts,rfc,guide} \
                  /usr/share/doc/openldap-2.4.44

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-slapd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
