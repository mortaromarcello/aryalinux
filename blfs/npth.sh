#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:npth:1.2



cd $SOURCE_DIR

URL=ftp://ftp.gnupg.org/gcrypt/npth/npth-1.2.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/npth/npth-1.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/npth/npth-1.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/npth/npth-1.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/npth/npth-1.2.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/npth/npth-1.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/npth/npth-1.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
echo "npth=>`date`" | sudo tee -a $INSTALLED_LIST

