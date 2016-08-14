#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:fltk-source:1.3.3

#REQ:x7lib
#REC:hicolor-icon-theme
#REC:libjpeg
#REC:libpng
#OPT:alsa-lib
#OPT:desktop-file-utils
#OPT:doxygen
#OPT:glu
#OPT:mesa
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://fltk.org/pub/fltk/1.3.3/fltk-1.3.3-source.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc http://fltk.org/pub/fltk/1.3.3/fltk-1.3.3-source.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -e '/cat./d' documentation/Makefile       &&
./configure --prefix=/usr    \
            --enable-shared  &&
make "-j`nproc`"


make -C documentation html



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/fltk-1.3.3 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "fltk=>`date`" | sudo tee -a $INSTALLED_LIST

