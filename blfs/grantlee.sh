#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Grantlee is a set of free software libraries written using the Qtbr3ak framework. Currently two libraries are shipped with Grantlee:br3ak Grantlee Templates and Grantlee TextDocument. The goal of Grantleebr3ak Templates is to make it easier for application developers tobr3ak separate the structure of documents from the data they contain,br3ak opening the door for theming.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cmake
#REQ:qt5


#VER:grantlee:5.1.0


NAME="grantlee"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz || wget -nc http://downloads.grantlee.org/grantlee-5.1.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/grantlee/grantlee-5.1.0.tar.gz


URL=http://downloads.grantlee.org/grantlee-5.1.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
