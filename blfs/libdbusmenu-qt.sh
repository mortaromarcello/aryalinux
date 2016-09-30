#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libdbusmenu-qt_.orig:0.9.3+16.04.20160218

#REQ:qt5
#OPT:doxygen


cd $SOURCE_DIR

URL=http://launchpad.net/ubuntu/+archive/primary/+files/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://launchpad.net/ubuntu/+archive/primary/+files/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DWITH_DOC=OFF              \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "libdbusmenu-qt=>`date`" | sudo tee -a $INSTALLED_LIST

