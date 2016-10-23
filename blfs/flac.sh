#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak FLAC is an audio CODEC similar tobr3ak MP3, but lossless, meaning that audio is compressed without losingbr3ak any information.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:libogg
#OPT:nasm
#OPT:docbook-utils
#OPT:doxygen
#OPT:valgrind


#VER:flac:1.3.1


NAME="flac"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://downloads.xiph.org/pub/xiph/releases/flac/flac-1.3.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/flac/flac-1.3.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/flac/flac-1.3.1.tar.xz || wget -nc http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/flac/flac-1.3.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/flac/flac-1.3.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/flac/flac-1.3.1.tar.xz


URL=http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --disable-thorough-tests &&
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
