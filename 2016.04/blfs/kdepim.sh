#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:kdepim:4.14.9

#REQ:boost
#REQ:grantlee
#REQ:kdepim-runtime
#REC:libassuan


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/15.04.2/src/kdepim-4.14.9.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kde/kdepim-4.14.9.tar.xz || wget -nc http://download.kde.org/stable/applications/15.04.2/src/kdepim-4.14.9.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kde/kdepim-4.14.9.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kde/kdepim-4.14.9.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kdepim-4.14.9.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kdepim-4.14.9.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

export KDE_PREFIX=/opt/kde


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
      -DSYSCONF_INSTALL_DIR=/etc         \
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
echo "kdepim=>`date`" | sudo tee -a $INSTALLED_LIST

