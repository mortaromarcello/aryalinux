#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:flac:1.3.1

#OPT:libogg
#OPT:nasm
#OPT:docbook-utils
#OPT:doxygen
#OPT:valgrind


cd $SOURCE_DIR

URL=http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz

wget -nc ftp://downloads.xiph.org/pub/xiph/releases/flac/flac-1.3.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/flac/flac-1.3.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/flac/flac-1.3.1.tar.xz || wget -nc http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/flac/flac-1.3.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/flac/flac-1.3.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/flac/flac-1.3.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --disable-thorough-tests &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "flac=>`date`" | sudo tee -a $INSTALLED_LIST

