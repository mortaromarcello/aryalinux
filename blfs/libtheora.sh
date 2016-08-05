#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libtheora:1.1.1

#REQ:libogg
#REC:libvorbis
#OPT:sdl
#OPT:libpng
#OPT:doxygen
#OPT:texlive
#OPT:tl-installer
#OPT:valgrind


cd $SOURCE_DIR

URL=http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz || wget -nc http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtheora/libtheora-1.1.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd examples/.libs &&
for E in *; do
  install -v -m755 $E /usr/bin/theora_${E}
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libtheora=>`date`" | sudo tee -a $INSTALLED_LIST

