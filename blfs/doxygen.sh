#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Doxygen package contains abr3ak documentation system for C++, C, Java, Objective-C, Corba IDL andbr3ak to some extent PHP, C# and D. It is useful for generating HTMLbr3ak documentation and/or an off-line reference manual from a set ofbr3ak documented source files. There is also support for generatingbr3ak output in RTF, PostScript, hyperlinked PDF, compressed HTML, andbr3ak Unix man pages. The documentation is extracted directly from thebr3ak sources, which makes it much easier to keep the documentationbr3ak consistent with the source code.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cmake
#OPT:graphviz
#OPT:gs
#OPT:libxml2
#OPT:llvm
#OPT:python2
#OPT:python3
#OPT:qt5
#OPT:texlive
#OPT:tl-installer
#OPT:xapian


#VER:doxygen-.src:1.8.12


NAME="doxygen"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/doxygen/doxygen-1.8.12.src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/doxygen/doxygen-1.8.12.src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/doxygen/doxygen-1.8.12.src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/doxygen/doxygen-1.8.12.src.tar.gz || wget -nc ftp://ftp.stack.nl/pub/doxygen/doxygen-1.8.12.src.tar.gz || wget -nc http://ftp.stack.nl/pub/doxygen/doxygen-1.8.12.src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/doxygen/doxygen-1.8.12.src.tar.gz


URL=http://ftp.stack.nl/pub/doxygen/doxygen-1.8.12.src.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -G "Unix Makefiles"         \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      .. &&
make "-j`nproc`" || make


cmake -DDOC_INSTALL_DIR=share/doc/doxygen-1.8.12 -Dbuild_doc=ON .. &&
make docs



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -vm644 ../doc/*.1 /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
