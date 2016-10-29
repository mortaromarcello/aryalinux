#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Fcron package contains abr3ak periodical command scheduler which aims at replacing Vixie Cron.br3ak"
SECTION="general"
VERSION=3.2.0
NAME="fcron"

#OPT:vim
#OPT:linux-pam
#OPT:docbook-utils


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://fcron.free.fr/archives/fcron-3.2.0.src.tar.gz


URL=http://fcron.free.fr/archives/fcron-3.2.0.src.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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
            --with-boot-install=no &&
make "-j`nproc`" || make



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
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
