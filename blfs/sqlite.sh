#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The SQLite package is a softwarebr3ak library that implements a self-contained, serverless,br3ak zero-configuration, transactional SQL database engine.br3ak
#SECTION:server

whoami > /tmp/currentuser

#OPT:unzip


#VER:sqlite-autoconf:3150000
#VER:sqlite-doc:3150000


NAME="sqlite"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3150000.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sqlite/sqlite-autoconf-3150000.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3150000.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3150000.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3150000.tar.gz || wget -nc http://sqlite.org/2016/sqlite-autoconf-3150000.tar.gz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-doc-3150000.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-doc-3150000.zip || wget -nc http://sqlite.org/2016/sqlite-doc-3150000.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sqlite/sqlite-doc-3150000.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-doc-3150000.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-doc-3150000.zip


URL=http://sqlite.org/2016/sqlite-autoconf-3150000.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

unzip -q ../sqlite-doc-3150000.zip


./configure --prefix=/usr --disable-static        \
            CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 \
            -DSQLITE_ENABLE_COLUMN_METADATA=1     \
            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1       \
            -DSQLITE_SECURE_DELETE=1              \
            -DSQLITE_ENABLE_DBSTAT_VTAB=1" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/sqlite-3.15.0 &&
cp -v -R sqlite-doc-3150000/* /usr/share/doc/sqlite-3.15.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
