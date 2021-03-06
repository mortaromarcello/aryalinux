#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak This package provides a Phononbr3ak backend which utilizes the VLCbr3ak media framework.br3ak"
SECTION="kde"
VERSION=0.9.0
NAME="phonon-backend-vlc"

#REQ:phonon
#REQ:vlc


cd $SOURCE_DIR

URL=http://download.kde.org/stable/phonon/phonon-backend-vlc/0.9.0/phonon-backend-vlc-0.9.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz || wget -nc http://download.kde.org/stable/phonon/phonon-backend-vlc/0.9.0/phonon-backend-vlc-0.9.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/phonon/phonon-backend-vlc-0.9.0.tar.xz

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
cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_INSTALL_LIBDIR=lib     \
      -DCMAKE_BUILD_TYPE=Release     \
      -DPHONON_BUILD_PHONON4QT5=ON   \
      -Wno-dev .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
