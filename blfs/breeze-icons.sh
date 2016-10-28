#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Breeze Icons package containsbr3ak the default icons for KDE Plasma 5br3ak applications, but it can be used for other window environments.br3ak
#SECTION:x

#REQ:extra-cmake-modules
#REQ:qt5


#VER:breeze-icons:5.25.0


NAME="breeze-icons"

wget -nc http://download.kde.org/stable/frameworks/5.25/breeze-icons-5.25.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/breeze-icons/breeze-icons-5.25.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/breeze-icons/breeze-icons-5.25.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/breeze-icons/breeze-icons-5.25.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/breeze-icons/breeze-icons-5.25.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/breeze-icons/breeze-icons-5.25.0.tar.xz


URL=http://download.kde.org/stable/frameworks/5.25/breeze-icons-5.25.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr -Wno-dev ..


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
