#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak This package provides the Mesa OpenGL Utility library.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:mesa


#VER:glu:9.0.0


NAME="glu"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2 || wget -nc ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2


URL=ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure --prefix=$XORG_PREFIX --disable-static &&
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
