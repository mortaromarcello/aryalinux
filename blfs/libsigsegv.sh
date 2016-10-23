#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak This is a library for handling page faults in user mode. A pagebr3ak fault occurs when a program tries to access to a region of memorybr3ak that is currently not available. Catching and handling a page faultbr3ak is a useful technique for implementing pageable virtual memory,br3ak memory-mapped access to persistent databases, generational garbagebr3ak collectors, stack overflow handlers, and distributed shared memory.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:libsigsegv:2.10


NAME="libsigsegv"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsigsegv/libsigsegv-2.10.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsigsegv/libsigsegv-2.10.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsigsegv/libsigsegv-2.10.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsigsegv/libsigsegv-2.10.tar.gz || wget -nc http://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.10.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsigsegv/libsigsegv-2.10.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.10.tar.gz


URL=http://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.10.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr   \
            --enable-shared \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
