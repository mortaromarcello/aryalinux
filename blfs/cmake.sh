#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The CMake package contains abr3ak modern toolset used for generating Makefiles. It is a successor ofbr3ak the auto-generated <span class="command"><strong>configure</strong> script and aims to bebr3ak platform- and compiler-independent. A significant user ofbr3ak CMake is KDE since version 4.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REC:curl
#REC:libarchive
#OPT:qt5
#OPT:subversion


#VER:cmake:3.6.2


NAME="cmake"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cmake/cmake-3.6.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cmake/cmake-3.6.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cmake/cmake-3.6.2.tar.gz || wget -nc http://www.cmake.org/files/v3.6/cmake-3.6.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cmake/cmake-3.6.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cmake/cmake-3.6.2.tar.gz


URL=http://www.cmake.org/files/v3.6/cmake-3.6.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./bootstrap --prefix=/usr       \
            --system-libs       \
            --mandir=/share/man \
            --no-system-jsoncpp \
            --docdir=/share/doc/cmake-3.6.2 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
