#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Kwayland is a Qt-style API tobr3ak interact with the wayland-clientbr3ak and wayland-server API.br3ak"
SECTION="lxqt"
VERSION=5.25.0
NAME="lxqt-kwayland"

#REQ:extra-cmake-modules
#REQ:mesa
#REQ:wayland
#REQ:qt5


wget -nc http://download.kde.org/stable/frameworks/5.25/kwayland-5.25.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kwayland/kwayland-5.25.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kwayland/kwayland-5.25.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kwayland/kwayland-5.25.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kwayland/kwayland-5.25.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kwayland/kwayland-5.25.0.tar.xz


URL=http://download.kde.org/stable/frameworks/5.25/kwayland-5.25.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX                          \
      -DCMAKE_BUILD_TYPE=Release                                   \
      -DCMAKE_INSTALL_LIBDIR=lib                                   \
      -DBUILD_TESTING=OFF                                          \
      -DECM_MKSPECS_INSTALL_DIR=$LXQT_PREFIX/share/mkspecs/modules \
      -Wno-dev ..                                                  &&
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
