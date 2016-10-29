#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libarchive library provides abr3ak single interface for reading/writing various compression formats.br3ak"
SECTION="general"
VERSION=3.2.1
NAME="libarchive"

#OPT:libxml2
#OPT:lzo
#OPT:nettle
#OPT:openssl


wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz || wget -nc http://www.libarchive.org/downloads/libarchive-3.2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz


URL=http://www.libarchive.org/downloads/libarchive-3.2.1.tar.gz
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
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
