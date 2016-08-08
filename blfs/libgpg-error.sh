#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libgpg-error:1.24



cd $SOURCE_DIR

URL=ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.24.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D README /usr/share/doc/libgpg-error-1.24/README

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libgpg-error=>`date`" | sudo tee -a $INSTALLED_LIST

