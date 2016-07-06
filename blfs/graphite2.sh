#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:graphite2:1.3.5

#REQ:cmake
#OPT:freetype2
#OPT:python2
#OPT:harfbuzz


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/silgraphite/graphite2-1.3.5.tgz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/graphite2/graphite2-1.3.5.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphite2/graphite2-1.3.5.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/graphite2/graphite2-1.3.5.tgz || wget -nc http://downloads.sourceforge.net/silgraphite/graphite2-1.3.5.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/graphite2/graphite2-1.3.5.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphite2/graphite2-1.3.5.tgz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/cmptest/d' tests/CMakeLists.txt


mkdir build &&
cd    build &&
cmake -G "Unix Makefiles"         \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "graphite2=>`date`" | sudo tee -a $INSTALLED_LIST

