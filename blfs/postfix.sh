#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:postfix:3.1.1

#REC:db
#REC:cyrus-sasl
#REC:openssl
#OPT:icu
#OPT:mariadb
#OPT:openldap
#OPT:pcre
#OPT:postgresql
#OPT:sqlite


cd $SOURCE_DIR

URL=ftp://ftp.porcupine.org/mirrors/postfix-release/official/postfix-3.1.1.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/postfix/postfix-3.1.1.tar.gz || wget -nc ftp://ftp.porcupine.org/mirrors/postfix-release/official/postfix-3.1.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/postfix/postfix-3.1.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/postfix/postfix-3.1.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/postfix/postfix-3.1.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/postfix/postfix-3.1.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 32 postfix &&
groupadd -g 33 postdrop &&
useradd -c "Postfix Daemon User" -d /var/spool/postfix -g postfix \
        -s /bin/false -u 32 postfix &&
chown -v postfix:postfix /var/mail

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i 's/.\x08//g' README_FILES/*


make CCARGS="-DUSE_TLS -I/usr/include/openssl/                     \
             -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/usr/include/sasl" \
     AUXLIBS="-lssl -lcrypto -lsasl2"                              \
     makefiles &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sh postfix-install -non-interactive \
   daemon_directory=/usr/lib/postfix \
   manpage_directory=/usr/share/man \
   html_directory=/usr/share/doc/postfix-3.1.1/html \
   readme_directory=/usr/share/doc/postfix-3.1.1/readme

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/aliases << "EOF"
# Begin /etc/aliases
MAILER-DAEMON: postmaster
postmaster: root
root: <em class="replaceable"><code><LOGIN></em>
# End /etc/aliases
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
/usr/sbin/postfix upgrade-configuration

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
/usr/sbin/postfix check &&
/usr/sbin/postfix start

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.08/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-postfix

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "postfix=>`date`" | sudo tee -a $INSTALLED_LIST

