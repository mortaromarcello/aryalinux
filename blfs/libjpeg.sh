#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libjpeg-turbo:1.5.0

#REQ:nasm
#REQ:yasm


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.0.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.0.tar.gz || wget -nc http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-jpeg8            \
            --disable-static        \
            --docdir=/usr/share/doc/libjpeg-turbo-1.5.0 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -f /usr/lib/libjpeg.so*

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libjpeg=>`date`" | sudo tee -a $INSTALLED_LIST

