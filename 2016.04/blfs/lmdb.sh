#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:LMDB_:0.9.18



cd $SOURCE_DIR

URL=https://github.com/LMDB/lmdb/archive/LMDB_0.9.18.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz || wget -nc https://github.com/LMDB/lmdb/archive/LMDB_0.9.18.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY


cd libraries/liblmdb &&
make                 &&
sed -i 's| liblmdb.a||' Makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "lmdb=>`date`" | sudo tee -a $INSTALLED_LIST

