#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libkcddb-2016-09:11

#REQ:libmusicbrainz5
#REQ:kframeworks5


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/libkcddb/libkcddb-2016-09-11.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz

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
      -Wno-dev ..                        &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libkcddb=>`date`" | sudo tee -a $INSTALLED_LIST
