#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak CLucene is a C++ version ofbr3ak Lucene, a high performance text search engine.br3ak"
SECTION="general"
VERSION=2.3.3.4
NAME="clucene"

#REQ:cmake
#REC:boost


wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clucene/clucene-core-2.3.3.4.tar.gz || wget -nc http://downloads.sourceforge.net/clucene/clucene-core-2.3.3.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clucene/clucene-core-2.3.3.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clucene/clucene-core-2.3.3.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clucene/clucene-core-2.3.3.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clucene/clucene-core-2.3.3.4.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/clucene-2.3.3.4-contribs_lib-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/clucene/clucene-2.3.3.4-contribs_lib-1.patch


URL=http://downloads.sourceforge.net/clucene/clucene-core-2.3.3.4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../clucene-2.3.3.4-contribs_lib-1.patch &&
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DBUILD_CONTRIBS_LIB=ON .. &&
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
