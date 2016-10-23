#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Polkit-Qt provides an API tobr3ak PolicyKit in the Qt environment.br3ak
#SECTION:kde

whoami > /tmp/currentuser

#REQ:cmake
#REQ:polkit
#REQ:qt5


#VER:polkit-qt-1:0.112.0


NAME="polkit-qt"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://download.kde.org/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/polkit-qt/polkit-qt-1-0.112.0.tar.bz2


URL=http://download.kde.org/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_LIBDIR=lib  \
      -Wno-dev .. &&
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