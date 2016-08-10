#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:at_.orig:3.1.20

#OPT:linux-pam


cd $SOURCE_DIR

URL=http://ftp.de.debian.org/debian/pool/main/a/at/at_3.1.20.orig.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/at/at_3.1.20.orig.tar.gz || wget -nc ftp://ftp.de.debian.org/debian/pool/main/a/at/at_3.1.20.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/at/at_3.1.20.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/at/at_3.1.20.orig.tar.gz || wget -nc http://ftp.de.debian.org/debian/pool/main/a/at/at_3.1.20.orig.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/at/at_3.1.20.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/at/at_3.1.20.orig.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 17 atd                                                  &&
useradd -d /dev/null -c "atd daemon" -g atd -s /bin/false -u 17 atd &&
mkdir -p /var/spool/cron

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i '/docdir/s/=.*/= @docdir@/' Makefile.in


autoreconf


./configure --with-daemon_username=atd        \
            --with-daemon_groupname=atd       \
            SENDMAIL=/usr/sbin/sendmail       \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install \
        docdir=/usr/share/doc/at-3.1.20 \
      atdocdir=/usr/share/doc/at-3.1.20

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable atd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "at=>`date`" | sudo tee -a $INSTALLED_LIST

