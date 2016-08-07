#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:freeglut:3.0.0

#REQ:cmake
#REQ:mesa
#REC:glu


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/freeglut/freeglut-3.0.0.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://downloads.sourceforge.net/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr      \
      -DCMAKE_BUILD_TYPE=Release       \
      -DFREEGLUT_BUILD_DEMOS=OFF       \
      -DFREEGLUT_BUILD_STATIC_LIBS=OFF \
      ..
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "freeglut=>`date`" | sudo tee -a $INSTALLED_LIST

