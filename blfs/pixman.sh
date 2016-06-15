#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pixman:0.34.0

#OPT:gtk2
#OPT:libpng


cd $SOURCE_DIR

URL=http://cairographics.org/releases/pixman-0.34.0.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pixman/pixman-0.34.0.tar.gz || wget -nc http://cairographics.org/releases/pixman-0.34.0.tar.gz

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
echo "pixman=>`date`" | sudo tee -a $INSTALLED_LIST

