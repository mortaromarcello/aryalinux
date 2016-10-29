#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak GNU Clisp is a Common Lispbr3ak implementation which includes an interpreter, compiler, debugger,br3ak and many extensions.br3ak"
SECTION="general"
VERSION=2.49
NAME="clisp"

#REC:libsigsegv


wget -nc http://ftp.gnu.org/pub/gnu/clisp/latest/clisp-2.49.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clisp/clisp-2.49.tar.bz2 || wget -nc ftp://ftp.gnu.org/pub/gnu/clisp/latest/clisp-2.49.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clisp/clisp-2.49.tar.bz2


URL=http://ftp.gnu.org/pub/gnu/clisp/latest/clisp-2.49.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -e '/socket/d' -e '/"streams"/d' tests/tests.lisp


mkdir build &&
cd    build &&
../configure --srcdir=../                       \
             --prefix=/usr                      \
             --docdir=/usr/share/doc/clisp-2.49 \
             --with-libsigsegv-prefix=/usr &&
ulimit -s 16384 &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
