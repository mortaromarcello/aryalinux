#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libkcddb package contains abr3ak library used to retrieve audio CD meta data from the internet.br3ak"
SECTION="kde"
VERSION=11
NAME="libkcddb"

#REQ:libmusicbrainz5
#REQ:kframeworks5


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/libkcddb/libkcddb-2016-09-11.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkcddb/libkcddb-2016-09-11.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -Wno-dev ..                        &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
