#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libatasmart:0.19



cd $SOURCE_DIR

URL=http://0pointer.de/public/libatasmart-0.19.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz || wget -nc http://0pointer.de/public/libatasmart-0.19.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/libatasmart-0.19 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libatasmart=>`date`" | sudo tee -a $INSTALLED_LIST

