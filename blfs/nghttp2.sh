#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak nghttp2 is an implementation ofbr3ak HTTP/2 and its header compression algorithm, HPACK.br3ak"
SECTION="basicnet"
VERSION=1.15.0
NAME="nghttp2"

#REQ:libxml2
#OPT:boost
#OPT:python2
#OPT:python-modules#setuptools


cd $SOURCE_DIR

URL=https://github.com/nghttp2/nghttp2/releases/download/v1.15.0/nghttp2-1.15.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://github.com/nghttp2/nghttp2/releases/download/v1.15.0/nghttp2-1.15.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nghttp2/nghttp2-1.15.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nghttp2/nghttp2-1.15.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nghttp2/nghttp2-1.15.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nghttp2/nghttp2-1.15.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nghttp2/nghttp2-1.15.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --enable-lib-only &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
