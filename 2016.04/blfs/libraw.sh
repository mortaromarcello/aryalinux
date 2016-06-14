#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:LibRaw:0.17.1

#REC:libjpeg
#REC:jasper
#REC:lcms2


cd $SOURCE_DIR

URL=http://www.libraw.org/data/LibRaw-0.17.1.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/LibRaw/LibRaw-0.17.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/LibRaw/LibRaw-0.17.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/LibRaw/LibRaw-0.17.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/LibRaw/LibRaw-0.17.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/LibRaw/LibRaw-0.17.1.tar.gz || wget -nc http://www.libraw.org/data/LibRaw-0.17.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr    \
            --enable-jpeg    \
            --enable-jasper  \
            --enable-lcms    \
            --disable-static \
            --docdir=/usr/share/doc/libraw-0.17.1 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libraw=>`date`" | sudo tee -a $INSTALLED_LIST

