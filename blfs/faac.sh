#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:faac:1.28



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/faac/faac-1.28.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/faac/faac-1.28.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/faac/faac-1.28.tar.bz2 || wget -nc http://downloads.sourceforge.net/faac/faac-1.28.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/faac/faac-1.28.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/faac/faac-1.28.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/faac/faac-1.28.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/downloads/faac/faac-1.28-glibc_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/faac-1.28-glibc_fixes-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../faac-1.28-glibc_fixes-1.patch &&
sed -i -e '/obj-type/d' -e '/Long Term/d' frontend/main.c &&
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
echo "faac=>`date`" | sudo tee -a $INSTALLED_LIST

