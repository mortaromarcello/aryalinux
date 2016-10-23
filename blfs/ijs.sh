#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The IJS package contains a librarybr3ak which implements a protocol for transmission of raster page images.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:ijs:0.35


NAME="ijs"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://www.openprinting.org/download/ijs/download/ijs-0.35.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ijs/ijs-0.35.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ijs/ijs-0.35.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ijs/ijs-0.35.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ijs/ijs-0.35.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ijs/ijs-0.35.tar.bz2


URL=https://www.openprinting.org/download/ijs/download/ijs-0.35.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --enable-shared \
            --disable-static &&
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
