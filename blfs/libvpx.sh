#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libvpx:1.5.0

#REQ:yasm
#REQ:nasm
#REQ:general_which
#OPT:doxygen
#OPT:php


cd $SOURCE_DIR

URL=http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libvpx/libvpx-1.5.0.tar.bz2 || wget -nc http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libvpx/libvpx-1.5.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libvpx/libvpx-1.5.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libvpx/libvpx-1.5.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libvpx/libvpx-1.5.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/cp -p/cp/' build/make/Makefile &&
mkdir libvpx-build            &&
cd    libvpx-build            &&
../configure --prefix=/usr    \
             --enable-shared  \
             --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libvpx=>`date`" | sudo tee -a $INSTALLED_LIST

