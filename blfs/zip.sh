#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:zip:30



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/infozip/zip30.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/zip/zip30.tgz || wget -nc ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/zip/zip30.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/zip/zip30.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/zip/zip30.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/zip/zip30.tgz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/zip/zip30.tar.gz || wget -nc http://downloads.sourceforge.net/infozip/zip30.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/zip/zip30.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/zip/zip30.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/zip/zip30.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/zip/zip30.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make -f unix/Makefile generic_gcc



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "zip=>`date`" | sudo tee -a $INSTALLED_LIST

