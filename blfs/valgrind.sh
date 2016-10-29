#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Valgrind is an instrumentationbr3ak framework for building dynamic analysis tools. There are Valgrindbr3ak tools that can automatically detect many memory management andbr3ak threading bugs, and profile programs in detail. Valgrind can alsobr3ak be used to build new tools.br3ak"
SECTION="general"
VERSION=3.11.0
NAME="valgrind"

#OPT:boost
#OPT:llvm
#OPT:gdb
#OPT:general_which
#OPT:bind
#OPT:bind-utils
#OPT:libxslt
#OPT:texlive
#OPT:tl-installer


wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/valgrind/valgrind-3.11.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/valgrind/valgrind-3.11.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/valgrind/valgrind-3.11.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/valgrind/valgrind-3.11.0.tar.bz2 || wget -nc http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/valgrind/valgrind-3.11.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/valgrind-3.11.0-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/valgrind/valgrind-3.11.0-upstream_fixes-1.patch


URL=http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../valgrind-3.11.0-upstream_fixes-1.patch


sed -i 's|/doc/valgrind||' docs/Makefile.in &&
./configure --prefix=/usr \
            --datadir=/usr/share/doc/valgrind-3.11.0 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
