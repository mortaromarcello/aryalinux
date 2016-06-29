#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:SDL:1.2.15

#OPT:aalib
#OPT:glu
#OPT:nasm
#OPT:pulseaudio
#OPT:pth
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://www.libsdl.org/release/SDL-1.2.15.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz || wget -nc http://www.libsdl.org/release/SDL-1.2.15.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/SDL/SDL-1.2.15.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/_XData32/s:register long:register _Xconst long:' \
    -i src/video/x11/SDL_x11sym.h &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/SDL-1.2.15/html &&
install -v -m644    docs/html/*.html \
                    /usr/share/doc/SDL-1.2.15/html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd test &&
./configure &&
make "-j`nproc`"


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "sdl=>`date`" | sudo tee -a $INSTALLED_LIST

