#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The xcb-proto package provides thebr3ak XML-XCB protocol descriptions that libxcb uses to generate the majority of itsbr3ak code and API.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:python2
#REQ:python3
#OPT:libxml2


#VER:xcb-proto:1.12


NAME="xcb-proto"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc http://xcb.freedesktop.org/dist/xcb-proto-1.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xcb-proto-1.12-python3-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/xcb-proto/xcb-proto-1.12-python3-1.patch
wget -nc http://www.linuxfromscratch.org/patches/downloads/xcb-proto/xcb-proto-1.12-schema-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xcb-proto-1.12-schema-1.patch


URL=http://xcb.freedesktop.org/dist/xcb-proto-1.12.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"


patch -Np1 -i ../xcb-proto-1.12-schema-1.patch


patch -Np1 -i ../xcb-proto-1.12-python3-1.patch


./configure $XORG_CONFIG



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
