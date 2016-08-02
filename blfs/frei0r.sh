#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:frei0r-plugins:1.5.0



cd $SOURCE_DIR

URL=https://files.dyne.org/frei0r/releases/frei0r-plugins-1.5.0.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz || wget -nc https://files.dyne.org/frei0r/releases/frei0r-plugins-1.5.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -vp build &&
cd        build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_BUILD_TYPE=Release     \
      -DOpenCV_DIR=/usr/share/OpenCV \
      -Wno-dev ..                    &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "frei0r=>`date`" | sudo tee -a $INSTALLED_LIST

