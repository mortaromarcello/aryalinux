#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:cups-pk-helper:0.2.5

#REQ:polkit


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/cups-pk-helper/releases/cups-pk-helper-0.2.5.tar.xz

wget -nc http://www.freedesktop.org/software/cups-pk-helper/releases/cups-pk-helper-0.2.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cups/cups-pk-helper-0.2.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.5.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "cups-pk-helper=>`date`" | sudo tee -a $INSTALLED_LIST

