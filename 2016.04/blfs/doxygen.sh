#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:doxygen-.src:1.8.11

#REQ:cmake
#OPT:graphviz
#OPT:gs
#OPT:libxml2
#OPT:llvm
#OPT:python2
#OPT:python3
#OPT:qt4
#OPT:qt5
#OPT:texlive
#OPT:tl-installer
#OPT:xapian


cd $SOURCE_DIR

URL=http://ftp.stack.nl/pub/doxygen/doxygen-1.8.11.src.tar.gz

wget -nc ftp://ftp.stack.nl/pub/doxygen/doxygen-1.8.11.src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/doxygen/doxygen-1.8.11.src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/doxygen/doxygen-1.8.11.src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/doxygen/doxygen-1.8.11.src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/doxygen/doxygen-1.8.11.src.tar.gz || wget -nc http://ftp.stack.nl/pub/doxygen/doxygen-1.8.11.src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/doxygen/doxygen-1.8.11.src.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

mkdir -v build &&
cd       build &&
cmake -G "Unix Makefiles"         \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      .. &&
make "-j`nproc`"


cmake -DDOC_INSTALL_DIR=share/doc/doxygen-1.8.11 -Dbuild_doc=ON .. &&
make docs



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -vm644 ../doc/*.1 /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "doxygen=>`date`" | sudo tee -a $INSTALLED_LIST

