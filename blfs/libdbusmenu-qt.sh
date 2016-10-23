#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak This library provides a Qtbr3ak implementation of the DBusMenu specification that exposes menus viabr3ak DBus.br3ak
#SECTION:kde

whoami > /tmp/currentuser

#REQ:qt5
#OPT:doxygen


#VER:libdbusmenu-qt_.orig:0.9.3+16.04.20160218


NAME="libdbusmenu-qt"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc http://launchpad.net/ubuntu/+archive/primary/+files/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdbusmenu/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz


URL=http://launchpad.net/ubuntu/+archive/primary/+files/libdbusmenu-qt_0.9.3+16.04.20160218.orig.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
