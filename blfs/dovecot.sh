#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:dovecot:2.2.21

#OPT:clucene
#OPT:icu
#OPT:libcap
#OPT:linux-pam
#OPT:mariadb
#OPT:mitkrb
#OPT:openldap
#OPT:openssl
#OPT:postgresql
#OPT:sqlite
#OPT:valgrind


cd $SOURCE_DIR

URL=http://www.dovecot.org/releases/2.2/dovecot-2.2.21.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dovecot/dovecot-2.2.21.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dovecot/dovecot-2.2.21.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dovecot/dovecot-2.2.21.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dovecot/dovecot-2.2.21.tar.gz || wget -nc http://www.dovecot.org/releases/2.2/dovecot-2.2.21.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dovecot/dovecot-2.2.21.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 42 dovecot &&
useradd -c "Dovecot unprivileged user" -d /dev/null -u 42 \
        -g dovecot -s /bin/false dovecot &&
groupadd -g 43 dovenull &&
useradd -c "Dovecot login user" -d /dev/null -u 43 \
        -g dovenull -s /bin/false dovenull

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --docdir=/usr/share/doc/dovecot-2.2.21 \
            --disable-static \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -rv /usr/share/doc/dovecot-2.2.21/example-config/* /etc/dovecot

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/^\!include / s/^/#/' /etc/dovecot/dovecot.conf &&
chmod -v 1777 /var/mail &&
cat > /etc/dovecot/local.conf << "EOF"
protocols = imap
ssl = no
# The next line is only needed if you have no IPv6 network interfaces
listen = *
mail_location = mbox:~/Mail:INBOX=/var/mail/%u
userdb {
 driver = passwd
}
passdb {
 driver = shadow
}
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable dovecot

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "dovecot=>`date`" | sudo tee -a $INSTALLED_LIST

