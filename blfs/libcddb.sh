#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libcddb:1.3.2



cd $SOURCE_DIR

URL=https://sourceforge.net/projects/libcddb/files/libcddb/1.3.2/libcddb-1.3.2.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc https://sourceforge.net/projects/libcddb/files/libcddb/1.3.2/libcddb-1.3.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libcddb=>`date`" | sudo tee -a $INSTALLED_LIST

