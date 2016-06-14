#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libdv:1.0.0

#OPT:popt
#OPT:sdl
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz || wget -nc http://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --disable-xv \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d      /usr/share/doc/libdv-1.0.0 &&
install -v -m644 README* /usr/share/doc/libdv-1.0.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libdv=>`date`" | sudo tee -a $INSTALLED_LIST

