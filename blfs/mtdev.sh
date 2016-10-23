#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The mtdev package containsbr3ak Multitouch Protocol Translation Library which is used to transformbr3ak all variants of kernel MT (Multitouch) events to the slotted type Bbr3ak protocol.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:mtdev:1.1.5


NAME="mtdev"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mtdev/mtdev-1.1.5.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mtdev/mtdev-1.1.5.tar.bz2 || wget -nc http://bitmath.org/code/mtdev/mtdev-1.1.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mtdev/mtdev-1.1.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mtdev/mtdev-1.1.5.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mtdev/mtdev-1.1.5.tar.bz2


URL=http://bitmath.org/code/mtdev/mtdev-1.1.5.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
