#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:unzip:60



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/infozip/unzip60.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://downloads.sourceforge.net/infozip/unzip60.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make -f unix/Makefile generic



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr MANDIR=/usr/share/man/man1 \
 -f unix/Makefile install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "unzip=>`date`" | sudo tee -a $INSTALLED_LIST

