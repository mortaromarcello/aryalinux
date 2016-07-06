#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libdbusmenu-qt:0.9.2

#REQ:qt4
#OPT:qjson
#OPT:doxygen


cd $SOURCE_DIR

URL=http://launchpad.net/libdbusmenu-qt/trunk/0.9.2/+download/libdbusmenu-qt-0.9.2.tar.bz2

wget -nc http://launchpad.net/libdbusmenu-qt/trunk/0.9.2/+download/libdbusmenu-qt-0.9.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt-0.9.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DWITH_DOC=OFF .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "general_libdbusmenu-qt=>`date`" | sudo tee -a $INSTALLED_LIST

