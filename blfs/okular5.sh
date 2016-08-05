#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:okular-15.12.1+df0c:412

#REQ:krameworks5
#REC:libkexiv2
#REC:libtiff
#REC:poppler
#OPT:qca


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/okular/okular-15.12.1+df0c412.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/okular/okular-15.12.1+df0c412.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
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
echo "okular5=>`date`" | sudo tee -a $INSTALLED_LIST

