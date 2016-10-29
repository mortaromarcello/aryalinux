#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libogg package contains thebr3ak Ogg file structure. This is useful for creating (encoding) orbr3ak playing (decoding) a single physical bit stream.br3ak"
SECTION="multimedia"
VERSION=1.3.2
NAME="libogg"



wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libogg/libogg-1.3.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libogg/libogg-1.3.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libogg/libogg-1.3.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libogg/libogg-1.3.2.tar.xz || wget -nc http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libogg/libogg-1.3.2.tar.xz || wget -nc ftp://downloads.xiph.org/pub/xiph/releases/ogg/libogg-1.3.2.tar.xz


URL=http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libogg-1.3.2 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
