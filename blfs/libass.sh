#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libass:0.13.2

#REQ:freetype2
#REQ:fribidi
#REC:fontconfig
#OPT:harfbuzz


cd $SOURCE_DIR

URL=https://github.com/libass/libass/releases/download/0.13.2/libass-0.13.2.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libass/libass-0.13.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libass/libass-0.13.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libass/libass-0.13.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libass/libass-0.13.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libass/libass-0.13.2.tar.xz || wget -nc https://github.com/libass/libass/releases/download/0.13.2/libass-0.13.2.tar.xz

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
echo "libass=>`date`" | sudo tee -a $INSTALLED_LIST

