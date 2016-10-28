#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak This package provides a Phononbr3ak backend which utilizes the VLCbr3ak media framework.br3ak
#SECTION:kde

#REQ:phonon
#REQ:vlc


#VER:phonon-backend-vlc:0.9.0


NAME="phonon-backend-vlc"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz || wget -nc http://download.kde.org/stable/phonon/phonon-backend-vlc/0.9.0/phonon-backend-vlc-0.9.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz


URL=http://download.kde.org/stable/phonon/phonon-backend-vlc/0.9.0/phonon-backend-vlc-0.9.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_INSTALL_LIBDIR=lib     \
      -DCMAKE_BUILD_TYPE=Release     \
      -DPHONON_BUILD_PHONON4QT5=ON   \
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
