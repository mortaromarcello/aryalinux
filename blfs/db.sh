#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:db:6.1.26

#OPT:tcl
#OPT:openjdk
#OPT:java
#OPT:sharutils


cd $SOURCE_DIR

URL=http://download.oracle.com/berkeley-db/db-6.1.26.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/db/db-6.1.26.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/db-6.1.26.tar.gz || wget -nc http://download.oracle.com/berkeley-db/db-6.1.26.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/db/db-6.1.26.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/db-6.1.26.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/db/db-6.1.26.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

cd build_unix                        &&
../dist/configure --prefix=/usr      \
                  --enable-compat185 \
                  --enable-dbm       \
                  --disable-static   \
                  --enable-cxx       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/db-6.1.26 install &&
chown -v -R root:root                        \
      /usr/bin/db_*                          \
      /usr/include/db{,_185,_cxx}.h          \
      /usr/lib/libdb*.{so,la}                \
      /usr/share/doc/db-6.1.26

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "db=>`date`" | sudo tee -a $INSTALLED_LIST

