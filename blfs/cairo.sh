#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:cairo:1.14.6

#REQ:libpng
#REQ:pixman
#REC:fontconfig
#REC:glib2
#REC:x7lib
#OPT:cogl
#OPT:gtk-doc
#OPT:libdrm
#OPT:lzo
#OPT:mesa
#OPT:valgrind


cd $SOURCE_DIR

URL=http://cairographics.org/releases/cairo-1.14.6.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairo-1.14.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairo-1.14.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairo-1.14.6.tar.xz || wget -nc http://cairographics.org/releases/cairo-1.14.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cairo/cairo-1.14.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairo-1.14.6.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --enable-tee &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "cairo=>`date`" | sudo tee -a $INSTALLED_LIST

