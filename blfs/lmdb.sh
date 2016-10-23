#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The lmdb package is a fast,br3ak compact, key-value embedded data store. It uses memory-mappedbr3ak files, so it has the read performance of a pure in-memory databasebr3ak while still offering the persistence of standard disk-basedbr3ak databases, and is only limited to the size of the virtual addressbr3ak spacebr3ak
#SECTION:server

whoami > /tmp/currentuser



#VER:LMDB_:0.9.18


NAME="lmdb"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lmdb/LMDB_0.9.18.tar.gz || wget -nc https://github.com/LMDB/lmdb/archive/LMDB_0.9.18.tar.gz


URL=https://github.com/LMDB/lmdb/archive/LMDB_0.9.18.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
