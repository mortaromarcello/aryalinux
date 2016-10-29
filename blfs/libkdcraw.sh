#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Libkdcraw is a KDE wrapper aroundbr3ak the <a class="xref" href="../general/libraw.html" title="libraw-0.17.2">libraw-0.17.2</a> library for manipulating imagebr3ak metadata.br3ak"
SECTION="kde"
VERSION=16.08.0
NAME="libkdcraw"

#REQ:libraw
#REQ:kframeworks5


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libkdcraw/libkdcraw-16.08.0.tar.xz || wget -nc http://download.kde.org/stable/applications/16.08.0/src/libkdcraw-16.08.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libkdcraw/libkdcraw-16.08.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkdcraw/libkdcraw-16.08.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libkdcraw/libkdcraw-16.08.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libkdcraw/libkdcraw-16.08.0.tar.xz


URL=http://download.kde.org/stable/applications/16.08.0/src/libkdcraw-16.08.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
