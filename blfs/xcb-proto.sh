#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The xcb-proto package provides thebr3ak XML-XCB protocol descriptions that libxcb uses to generate the majority of itsbr3ak code and API.br3ak"
SECTION="x"
VERSION=1.12
NAME="xcb-proto"

#REQ:python2
#REQ:python3
#OPT:libxml2


cd $SOURCE_DIR

URL=http://xcb.freedesktop.org/dist/xcb-proto-1.12.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc http://xcb.freedesktop.org/dist/xcb-proto-1.12.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xcb-proto-1.12-python3-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/xcb-proto/xcb-proto-1.12-python3-1.patch
wget -nc http://www.linuxfromscratch.org/patches/downloads/xcb-proto/xcb-proto-1.12-schema-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xcb-proto-1.12-schema-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
