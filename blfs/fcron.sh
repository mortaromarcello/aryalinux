#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:fcron-.src:3.2.0

#OPT:vim
#OPT:linux-pam
#OPT:docbook-utils


cd $SOURCE_DIR

URL=http://fcron.free.fr/archives/fcron-3.2.0.src.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://fcron.free.fr/archives/fcron-3.2.0.src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 22 fcron &&
useradd -d /dev/null -c "Fcron User" -g fcron -s /bin/false -u 22 fcron

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --localstatedir=/var   \
            --without-sendmail     \
            --without-boot-install &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable fcron

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "fcron=>`date`" | sudo tee -a $INSTALLED_LIST

