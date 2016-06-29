#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libxkbcommon:0.6.1

#REQ:xkeyboard-config
#REC:libxcb


cd $SOURCE_DIR

URL=http://xkbcommon.org/download/libxkbcommon-0.6.1.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc http://xkbcommon.org/download/libxkbcommon-0.6.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --docdir=/usr/share/doc/libxkbcommon-0.6.1 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libxkbcommon=>`date`" | sudo tee -a $INSTALLED_LIST

