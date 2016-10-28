#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The kwindowsystem providesbr3ak information about, and allows interaction with, the windowingbr3ak system. It provides a high level API that is windowing systembr3ak independent and has platform specific implementations.br3ak
#SECTION:lxqt

#REQ:extra-cmake-modules
#REQ:x7lib
#REQ:qt5


#VER:kwindowsystem:5.25.0


NAME="lxqt-kwindowsystem"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kwindowsystem/kwindowsystem-5.25.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kwindowsystem/kwindowsystem-5.25.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kwindowsystem/kwindowsystem-5.25.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kwindowsystem/kwindowsystem-5.25.0.tar.xz || wget -nc http://download.kde.org/stable/frameworks/5.25/kwindowsystem-5.25.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kwindowsystem/kwindowsystem-5.25.0.tar.xz


URL=http://download.kde.org/stable/frameworks/5.25/kwindowsystem-5.25.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

mkdir -v build &&
cd       build &&

cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      -DBUILD_TESTING=OFF                 \
      -Wno-dev ..                         &&
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
