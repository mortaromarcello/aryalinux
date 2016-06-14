#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:baloo-widgets:4.14.3

#REQ:kde_baloo


cd $SOURCE_DIR

URL=http://download.kde.org/stable/4.14.3/src/baloo-widgets-4.14.3.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/baloo-widgets/baloo-widgets-4.14.3.tar.xz || wget -nc http://download.kde.org/stable/4.14.3/src/baloo-widgets-4.14.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/baloo-widgets/baloo-widgets-4.14.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/baloo-widgets/baloo-widgets-4.14.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/baloo-widgets/baloo-widgets-4.14.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/baloo-widgets/baloo-widgets-4.14.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

export KDE_PREFIX=/opt/kde


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
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
echo "baloo-widgets=>`date`" | sudo tee -a $INSTALLED_LIST

