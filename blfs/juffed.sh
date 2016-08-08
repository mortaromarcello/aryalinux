#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:juffed-0.10.r71.gcc1af:3

#REQ:qscintilla
#REC:qtermwidget
#OPT:desktop-file-utils


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz

wget -nc http://anduin.linuxfromscratch.org/BLFS/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DLIB_INSTALL_DIR=/usr/lib  \
      -DBUILD_TERMINAL=ON         \
      -DUSE_QT5=true              \
      ..       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "juffed=>`date`" | sudo tee -a $INSTALLED_LIST

