#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Kdenlive package is a KF5br3ak based video editor.br3ak
#SECTION:kde

#REQ:krameworks5
#REQ:mlt
#REQ:v4l-utils


#VER:kdenlive:16.08.0


NAME="kdenlive"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kde/kdenlive-16.08.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kdenlive-16.08.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kdenlive-16.08.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kde/kdenlive-16.08.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kde/kdenlive-16.08.0.tar.xz || wget -nc http://download.kde.org/stable/applications/16.08.0/src/kdenlive-16.08.0.tar.xz


URL=http://download.kde.org/stable/applications/16.08.0/src/kdenlive-16.08.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
