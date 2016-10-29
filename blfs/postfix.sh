#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Postfix package contains abr3ak Mail Transport Agent (MTA). This is useful for sending email tobr3ak other users of your host machine. It can also be configured to be abr3ak central mail server for your domain, a mail relay agent or simply abr3ak mail delivery agent to your local Internet Service Provider.br3ak"
SECTION="server"
VERSION=3.1.2
NAME="postfix"

#REC:db
#REC:cyrus-sasl
#REC:openssl
#OPT:icu
#OPT:mariadb
#OPT:openldap
#OPT:pcre
#OPT:postgresql
#OPT:sqlite


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/postfix/postfix-3.1.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/postfix/postfix-3.1.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/postfix/postfix-3.1.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/postfix/postfix-3.1.2.tar.gz || wget -nc ftp://ftp.porcupine.org/mirrors/postfix-release/official/postfix-3.1.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/postfix/postfix-3.1.2.tar.gz


URL=ftp://ftp.porcupine.org/mirrors/postfix-release/official/postfix-3.1.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sh postfix-install -non-interactive \
   daemon_directory=/usr/lib/postfix \
   manpage_directory=/usr/share/man \
   html_directory=/usr/share/doc/postfix-3.1.2/html \
   readme_directory=/usr/share/doc/postfix-3.1.2/readme

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
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-postfix

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
