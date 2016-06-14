#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:opus:1.1.2

#OPT:doxygen
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://downloads.xiph.org/releases/opus/opus-1.1.2.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/opus/opus-1.1.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/opus/opus-1.1.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/opus/opus-1.1.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/opus/opus-1.1.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/opus/opus-1.1.2.tar.gz || wget -nc http://downloads.xiph.org/releases/opus/opus-1.1.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/opus-1.1.2 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "opus=>`date`" | sudo tee -a $INSTALLED_LIST

