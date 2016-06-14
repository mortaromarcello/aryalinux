#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:harfbuzz:1.1.3

#REC:glib2
#REC:icu
#REC:freetype2-without-harfbuzz
#OPT:cairo
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:graphite2


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.1.3.tar.bz2

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/harfbuzz/harfbuzz-1.1.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.1.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.1.3.tar.bz2 || wget -nc http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.1.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.1.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.1.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --with-gobject &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "harfbuzz=>`date`" | sudo tee -a $INSTALLED_LIST

