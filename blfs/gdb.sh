#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gdb:7.11

#OPT:dejagnu
#OPT:doxygen
#OPT:guile
#OPT:python2
#OPT:valgrind


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/gdb/gdb-7.11.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gdb/gdb-7.11.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdb/gdb-7.11.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/gdb/gdb-7.11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gdb/gdb-7.11.tar.xz || wget -nc https://ftp.gnu.org/gnu/gdb/gdb-7.11.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdb/gdb-7.11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gdb/gdb-7.11.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
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
echo "gdb=>`date`" | sudo tee -a $INSTALLED_LIST

