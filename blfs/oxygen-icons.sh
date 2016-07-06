#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:oxygen-icons:15.04.3

#REQ:cmake


cd $SOURCE_DIR

URL=http://download.kde.org/Attic/applications/15.04.3/src/oxygen-icons-15.04.3.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/oxygen-icons/oxygen-icons-15.04.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/oxygen-icons/oxygen-icons-15.04.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/oxygen-icons/oxygen-icons-15.04.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/oxygen-icons/oxygen-icons-15.04.3.tar.xz || wget -nc http://download.kde.org/Attic/applications/15.04.3/src/oxygen-icons-15.04.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/oxygen-icons/oxygen-icons-15.04.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "s/x256/& scalable/" CMakeLists.txt &&
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr -Wno-dev ..



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "oxygen-icons=>`date`" | sudo tee -a $INSTALLED_LIST

