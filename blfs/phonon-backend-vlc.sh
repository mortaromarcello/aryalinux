#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:phonon-backend-vlc:0.8.2

#REQ:phonon
#REQ:vlc


cd $SOURCE_DIR

URL=http://download.kde.org/stable/phonon/phonon-backend-vlc/0.8.2/src/phonon-backend-vlc-0.8.2.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.8.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.8.2.tar.xz || wget -nc ftp://ftp.kde.org/pub/kde/stable/phonon/phonon-backend-vlc/0.8.2/src/phonon-backend-vlc-0.8.2.tar.xz || wget -nc http://download.kde.org/stable/phonon/phonon-backend-vlc/0.8.2/src/phonon-backend-vlc-0.8.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/phonon/phonon-backend-vlc-0.8.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.8.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.8.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export KDE_PREFIX=/opt/kde


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib         \
      -DCMAKE_BUILD_TYPE=Release         \
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
echo "phonon-backend-vlc=>`date`" | sudo tee -a $INSTALLED_LIST

