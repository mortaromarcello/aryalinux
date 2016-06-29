#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:phonon:4.8.3

#REQ:cmake
#REQ:glib2
#REQ:qt5
#OPT:pulseaudio


cd $SOURCE_DIR

URL=http://download.kde.org/stable/phonon/4.8.3/src/phonon-4.8.3.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-4.8.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/phonon/phonon-4.8.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-4.8.3.tar.xz || wget -nc http://download.kde.org/stable/phonon/4.8.3/src/phonon-4.8.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-4.8.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-4.8.3.tar.xz || wget -nc ftp://ftp.kde.org/pub/kde/stable/phonon/4.8.3/src/phonon-4.8.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export KDE_PREFIX=/opt/kde


sed -i "s:BSD_SOURCE:DEFAULT_SOURCE:g" cmake/FindPhononInternal.cmake


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX                  \
      -DCMAKE_BUILD_TYPE=Release                          \
      -DCMAKE_INSTALL_LIBDIR=lib                          \
      -DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=FALSE \
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
echo "phonon=>`date`" | sudo tee -a $INSTALLED_LIST

