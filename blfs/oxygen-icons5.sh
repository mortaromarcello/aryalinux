#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The oxygen icons 5 theme is a photo-realistic icon style, with abr3ak high standard of graphics quality.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:extra-cmake-modules
#REQ:qt5


#VER:oxygen-icons5:5.25.0


NAME="oxygen-icons5"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/oxygen-icons/oxygen-icons5-5.25.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/oxygen-icons/oxygen-icons5-5.25.0.tar.xz || wget -nc http://download.kde.org/stable/frameworks/5.25/oxygen-icons5-5.25.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/oxygen-icons/oxygen-icons5-5.25.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/oxygen-icons/oxygen-icons5-5.25.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/oxygen-icons/oxygen-icons5-5.25.0.tar.xz


URL=http://download.kde.org/stable/frameworks/5.25/oxygen-icons5-5.25.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/( oxygen/ s/)/scalable )/' \
    -i CMakeLists.txt


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
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
