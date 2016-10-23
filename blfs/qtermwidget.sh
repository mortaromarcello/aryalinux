#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak As the name suggests, the qtermwidget is a terminal widget forbr3ak Qt.br3ak
#SECTION:lxqt

whoami > /tmp/currentuser

#REQ:cmake
#REQ:qt5


#VER:qtermwidget:0.6.0


NAME="qtermwidget"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qtermwidget/qtermwidget-0.6.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qtermwidget/qtermwidget-0.6.0.tar.xz || wget -nc https://github.com/qterminal/qtermwidget/releases/download/0.6.0/qtermwidget-0.6.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtermwidget/qtermwidget-0.6.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtermwidget/qtermwidget-0.6.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qtermwidget/qtermwidget-0.6.0.tar.xz


URL=https://github.com/qterminal/qtermwidget/releases/download/0.6.0/qtermwidget-0.6.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_INSTALL_LIBDIR=lib  \
      -DBUILD_DESIGNER_PLUGIN=0   \
      -DUSE_QT5=true              \
      ..       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
