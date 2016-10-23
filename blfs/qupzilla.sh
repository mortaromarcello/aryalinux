#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak QupZilla is a fast, feature-richbr3ak and lightweight QtWebEngine basedbr3ak browser, originally intended only for educational purposes.br3ak
#SECTION:lxqt

whoami > /tmp/currentuser

#REQ:cmake
#REQ:openssl
#REQ:qt5
#OPT:gdb


#VER:QupZilla:2.0.1


NAME="qupzilla"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz || wget -nc https://github.com/QupZilla/qupzilla/releases/download/v2.0.1/QupZilla-2.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qupzilla/QupZilla-2.0.1.tar.xz


URL=https://github.com/QupZilla/qupzilla/releases/download/v2.0.1/QupZilla-2.0.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export QUPZILLA_PREFIX=/usr &&
qmake                       &&
make "-j`nproc`" || make



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
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
