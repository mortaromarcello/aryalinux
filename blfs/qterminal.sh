#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:qterminal:0.6.0

#REQ:qtermwidget
#OPT:doxygen
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://github.com/qterminal/qterminal/releases/download/0.6.0/qterminal-0.6.0.tar.xz

wget -nc https://github.com/qterminal/qterminal/releases/download/0.6.0/qterminal-0.6.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qterminal/qterminal-0.6.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qterminal/qterminal-0.6.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qterminal/qterminal-0.6.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qterminal/qterminal-0.6.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qterminal/qterminal-0.6.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DUSE_SYSTEM_QXT=OFF        \
      -DUSE_QT5=true              \
      ..       &&
make "-j`nproc`"


make -C docs/latex



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "qterminal=>`date`" | sudo tee -a $INSTALLED_LIST

