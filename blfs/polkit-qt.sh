#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:polkit-qt-1:0.112.0

#REQ:cmake
#REQ:polkit
#REQ:qt5


cd $SOURCE_DIR

URL=http://download.kde.org/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://download.kde.org/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_LIBDIR=lib  \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "polkit-qt=>`date`" | sudo tee -a $INSTALLED_LIST

