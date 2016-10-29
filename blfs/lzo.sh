#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak LZO is a data compression librarybr3ak which is suitable for data decompression and compression inbr3ak real-time. This means it favors speed over compression ratio.br3ak"
SECTION="general"
VERSION=2.09
NAME="lzo"



wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lzo/lzo-2.09.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lzo/lzo-2.09.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lzo/lzo-2.09.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lzo/lzo-2.09.tar.gz || wget -nc http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lzo/lzo-2.09.tar.gz


URL=http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                    \
            --enable-shared                  \
            --disable-static                 \
            --docdir=/usr/share/doc/lzo-2.09 &&
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
