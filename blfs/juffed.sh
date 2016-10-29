#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The JuffEd package is a Qt basedbr3ak editor with support for multiple tabs. It is simple and clear, butbr3ak very powerful. It supports language syntax highlighting,br3ak auto-indents in accordance with file type, code blocks folding,br3ak matching braces highlighting with instant jumps between them,br3ak powerful search and replacing text using regular expressionsbr3ak (including multiline ones) with the opportunity to use matches \1,br3ak \2, … in substitutions, a terminal emulator, saving namedbr3ak sessions and many other features.br3ak"
SECTION="lxqt"
VERSION=3
NAME="juffed"

#REQ:qscintilla
#REC:qtermwidget
#OPT:desktop-file-utils


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/juffed/juffed-0.10.r71.gc3c1a3f.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DLIB_INSTALL_DIR=/usr/lib  \
      -DBUILD_TERMINAL=ON         \
      -DUSE_QT5=true              \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
