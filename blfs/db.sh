#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Berkeley DB package containsbr3ak programs and utilities used by many other applications for databasebr3ak related functions.br3ak
#SECTION:server

whoami > /tmp/currentuser

#OPT:tcl
#OPT:openjdk
#OPT:java
#OPT:sharutils


#VER:db:6.2.23


NAME="db"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/db/db-6.2.23.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/db/db-6.2.23.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/db/db-6.2.23.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/db-6.2.23.tar.gz || wget -nc http://download.oracle.com/berkeley-db/db-6.2.23.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/db-6.2.23.tar.gz


URL=http://download.oracle.com/berkeley-db/db-6.2.23.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd build_unix                        &&
../dist/configure --prefix=/usr      \
                  --enable-compat185 \
                  --enable-dbm       \
                  --disable-static   \
                  --enable-cxx       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/db-6.2.23 install &&
chown -v -R root:root                        \
      /usr/bin/db_*                          \
      /usr/include/db{,_185,_cxx}.h          \
      /usr/lib/libdb*.{so,la}                \
      /usr/share/doc/db-6.2.23

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
