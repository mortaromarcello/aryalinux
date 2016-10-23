#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Extra Cmake Modules packagebr3ak contains extra CMake modules usedbr3ak by KDE Frameworks 5 and otherbr3ak packages.br3ak
#SECTION:kde

whoami > /tmp/currentuser

#REQ:cmake


#VER:extra-cmake-modules:5.25.0


NAME="extra-cmake-modules"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.25.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.25.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.25.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.25.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/extra-cmake-modules/extra-cmake-modules-5.25.0.tar.xz || wget -nc http://download.kde.org/stable/frameworks/5.25/extra-cmake-modules-5.25.0.tar.xz


URL=http://download.kde.org/stable/frameworks/5.25/extra-cmake-modules-5.25.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
