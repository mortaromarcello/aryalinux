#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Taglib is a library used forbr3ak reading, writing and manipulating audio file tags and is used bybr3ak applications such as Amarok andbr3ak VLC.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:cmake


#VER:taglib:1.11


NAME="taglib"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/taglib/taglib-1.11.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/taglib/taglib-1.11.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/taglib/taglib-1.11.tar.gz || wget -nc https://taglib.github.io/releases/taglib-1.11.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/taglib/taglib-1.11.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/taglib/taglib-1.11.tar.gz


URL=https://taglib.github.io/releases/taglib-1.11.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DBUILD_SHARED_LIBS=ON \
      .. &&
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
