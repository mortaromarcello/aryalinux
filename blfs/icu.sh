#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:icu4c-src:56_1

#OPT:llvm
#OPT:doxygen


cd $SOURCE_DIR

URL=http://download.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.tgz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-56_1-src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-56_1-src.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-56_1-src.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-56_1-src.tgz || wget -nc http://download.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icu/icu4c-56_1-src.tgz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd source &&
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "icu=>`date`" | sudo tee -a $INSTALLED_LIST

