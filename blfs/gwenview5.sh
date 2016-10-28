#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Gwenview is a fast and easy-to-usebr3ak image viewer for KDE.br3ak
#SECTION:kde

#REQ:exiv2
#REQ:krameworks5
#REQ:lcms2
#REC:libkdcraw


#VER:gwenview:16.08.0


NAME="gwenview5"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gwenview/gwenview-16.08.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gwenview/gwenview-16.08.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gwenview/gwenview-16.08.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gwenview/gwenview-16.08.0.tar.xz || wget -nc http://download.kde.org/stable/applications/16.08.0/src/gwenview-16.08.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gwenview/gwenview-16.08.0.tar.xz


URL=http://download.kde.org/stable/applications/16.08.0/src/gwenview-16.08.0.tar.xz
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
