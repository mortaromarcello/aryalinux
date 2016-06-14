#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libical:2.0.0

#REQ:cmake
#OPT:db
#OPT:doxygen
#OPT:gobject-introspection
#OPT:icu


cd $SOURCE_DIR

URL=https://github.com/libical/libical/releases/download/v2.0.0/libical-2.0.0.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libical/libical-2.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libical/libical-2.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libical/libical-2.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libical/libical-2.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libical/libical-2.0.0.tar.gz || wget -nc https://github.com/libical/libical/releases/download/v2.0.0/libical-2.0.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DSHARED_ONLY=yes           \
      .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libical=>`date`" | sudo tee -a $INSTALLED_LIST

