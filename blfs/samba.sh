#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:samba:4.4.3

#REQ:python2
#REC:libxslt
#REC:openldap
#OPT:avahi
#OPT:cups
#OPT:gnutls
#OPT:libarchive
#OPT:libcap
#OPT:libgpg-error
#OPT:linux-pam
#OPT:mitkrb
#OPT:popt
#OPT:python3
#OPT:talloc
#OPT:valgrind
#OPT:xfsprogs


cd $SOURCE_DIR

URL=https://download.samba.org/pub/samba/stable/samba-4.4.2.tar.gz

wget -nc https://download.samba.org/pub/samba/stable/samba-4.4.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure                             \
    --prefix=/usr                       \
    --sysconfdir=/etc                   \
    --localstatedir=/var                \
    --with-piddir=/run/samba            \
    --with-pammodulesdir=/lib/security  \
    --enable-fhs                        &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v /usr/lib/libnss_win{s,bind}.so*   /lib                       &&
ln -v -sf ../../lib/libnss_winbind.so.2 /usr/lib/libnss_winbind.so &&
ln -v -sf ../../lib/libnss_wins.so.2    /usr/lib/libnss_wins.so    &&
install -v -m644    examples/smb.conf.default /etc/samba &&
mkdir -pv /etc/openldap/schema                        &&
install -v -m644    examples/LDAP/README              \
                    /etc/openldap/schema/README.LDAP  &&
install -v -m644    examples/LDAP/samba*              \
                    /etc/openldap/schema              &&
install -v -m755    examples/LDAP/{get*,ol*} \
                    /etc/openldap/schema

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -sf /usr/bin/smbspool /usr/lib/cups/backend/smb

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.07/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-samba

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.07/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-winbindd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl stop smbd &&
systemctl disable smbd &&
systemctl enable smbd.socket &&
systemctl start smbd.socket

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "samba=>`date`" | sudo tee -a $INSTALLED_LIST

