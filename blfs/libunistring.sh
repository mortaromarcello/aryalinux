#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak libunistring is a library that provides functions for manipulatingbr3ak Unicode strings and for manipulating C strings according to thebr3ak Unicode standard.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:texlive
#OPT:tl-installer


#VER:libunistring:0.9.6


NAME="libunistring"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnu.org/gnu/libunistring/libunistring-0.9.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libunistring/libunistring-0.9.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libunistring/libunistring-0.9.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libunistring/libunistring-0.9.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libunistring/libunistring-0.9.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libunistring/libunistring-0.9.6.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/libunistring/libunistring-0.9.6.tar.xz


URL=http://ftp.gnu.org/gnu/libunistring/libunistring-0.9.6.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-0.9.6 &&
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
