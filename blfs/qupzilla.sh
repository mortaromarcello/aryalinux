#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:QupZilla:2.0.1

#REQ:cmake
#REQ:openssl
#REQ:qt5
#OPT:gdb


cd $SOURCE_DIR

URL=https://github.com/QupZilla/qupzilla/releases/download/v2.0.1/QupZilla-2.0.1.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz || wget -nc https://github.com/QupZilla/qupzilla/releases/download/v2.0.1/QupZilla-2.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export QUPZILLA_PREFIX=/usr &&
qmake                       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
xdg-icon-resource forceupdate --theme hicolor &&
update-desktop-database -q

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "qupzilla=>`date`" | sudo tee -a $INSTALLED_LIST

