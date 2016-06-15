#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:qimageblitz:0.0.6

#REQ:cmake
#REQ:qt4


cd $SOURCE_DIR

URL=http://download.kde.org/stable/qimageblitz/qimageblitz-0.0.6.tar.bz2

wget -nc ftp://ftp.kde.org/pub/kde/stable/qimageblitz/qimageblitz-0.0.6.tar.bz2 || wget -nc http://download.kde.org/stable/qimageblitz/qimageblitz-0.0.6.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export KDE_PREFIX=/opt/kde


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "qimageblitz=>`date`" | sudo tee -a $INSTALLED_LIST

