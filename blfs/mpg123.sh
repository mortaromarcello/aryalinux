#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mpg123:1.23.0

#REC:alsa-lib
#OPT:pulseaudio
#OPT:sdl


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/mpg123/mpg123-1.23.0.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mpg123/mpg123-1.23.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mpg123/mpg123-1.23.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mpg123/mpg123-1.23.0.tar.bz2 || wget -nc http://downloads.sourceforge.net/mpg123/mpg123-1.23.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mpg123/mpg123-1.23.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mpg123/mpg123-1.23.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --with-module-suffix=.so &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mpg123=>`date`" | sudo tee -a $INSTALLED_LIST

