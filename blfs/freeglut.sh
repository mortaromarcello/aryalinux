#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Freeglut is intended to be a 100%br3ak compatible, completely opensourced clone of the GLUT library. GLUTbr3ak is a window system independent toolkit for writing OpenGL programs,br3ak implementing a simple windowing API, which makes learning about andbr3ak exploring OpenGL programming very easy.br3ak"
SECTION="x"
VERSION=3.0.0
NAME="freeglut"

#REQ:cmake
#REQ:mesa
#REC:glu


wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://downloads.sourceforge.net/freeglut/freeglut-3.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freeglut/freeglut-3.0.0.tar.gz


URL=http://downloads.sourceforge.net/freeglut/freeglut-3.0.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr      \
      -DCMAKE_BUILD_TYPE=Release       \
      -DFREEGLUT_BUILD_DEMOS=OFF       \
      -DFREEGLUT_BUILD_STATIC_LIBS=OFF \
      .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
