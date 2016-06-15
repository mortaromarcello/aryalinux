#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ncftp-src:3.2.5



cd $SOURCE_DIR

URL=ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ncftp/ncftp-3.2.5-src.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make -C libncftp shared &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C libncftp soinstall &&
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ncftp=>`date`" | sudo tee -a $INSTALLED_LIST

