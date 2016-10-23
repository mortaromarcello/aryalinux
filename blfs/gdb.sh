#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak GDB, the GNU Project debugger,br3ak allows you to see what is going on “<span class="quote">inside” another program while it executes --br3ak or what another program was doing at the moment it crashed. Notebr3ak that GDB is most effective whenbr3ak tracing programs and libraries that were built with debuggingbr3ak symbols and not stripped.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:dejagnu
#OPT:doxygen
#OPT:guile
#OPT:python2
#OPT:valgrind


#VER:gdb:7.12


NAME="gdb"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdb/gdb-7.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gdb/gdb-7.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdb/gdb-7.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gdb/gdb-7.12.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gdb/gdb-7.12.tar.xz || wget -nc https://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz


URL=https://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --with-system-readline &&
make "-j`nproc`"


make -C gdb/doc doxy


pushd gdb/testsuite &&
make  site.exp      &&
echo  "set gdb_test_timeout 120" >> site.exp &&
runtest TRANSCRIPT=y
popd



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C gdb install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
