#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak FLTK (pronounced "fulltick") is a cross-platform C++ GUI toolkit.br3ak FLTK provides modern GUI functionality and supports 3D graphics viabr3ak OpenGL and its built-in GLUT emulation libraries used for creatingbr3ak graphical user interfaces for applications.br3ak
#SECTION:x

whoami > /tmp/currentuser

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


#VER:fltk-source:1.3.3


NAME="fltk"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fltk/fltk-1.3.3-source.tar.gz || wget -nc http://fltk.org/pub/fltk/1.3.3/fltk-1.3.3-source.tar.gz


URL=http://fltk.org/pub/fltk/1.3.3/fltk-1.3.3-source.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -e '/cat./d' documentation/Makefile       &&
./configure --prefix=/usr    \
            --enable-shared  &&
make "-j`nproc`" || make


make -C documentation html



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/fltk-1.3.3 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
