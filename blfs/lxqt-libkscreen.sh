#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Libkscreen package containsbr3ak the KDE Screen Management library.br3ak"
SECTION="lxqt"
VERSION=5.7.3
NAME="lxqt-libkscreen"

#REQ:lxqt-kwayland


cd $SOURCE_DIR

URL=http://download.kde.org/stable/plasma/5.7.3/libkscreen-5.7.3.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz || wget -nc http://download.kde.org/stable/plasma/5.7.3/libkscreen-5.7.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libkscreen/libkscreen-5.7.3.tar.xz

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

mkdir -pv build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      -DBUILD_TESTING=OFF                 \
      -Wno-dev ..                         &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
