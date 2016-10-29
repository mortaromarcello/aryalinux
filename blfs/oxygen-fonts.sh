#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The oxygen-fonts package is a setbr3ak of fonts used by KF5.br3ak"
SECTION="kde"
VERSION=5.4.3
NAME="oxygen-fonts"

#REQ:cmake
#REQ:fontforge


wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz || wget -nc http://download.kde.org/stable/plasma/5.4.3/oxygen-fonts-5.4.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz


URL=http://download.kde.org/stable/plasma/5.4.3/oxygen-fonts-5.4.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr ..



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
