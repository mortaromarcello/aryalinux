#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:json-c:0.12.1



cd $SOURCE_DIR

URL=https://s3.amazonaws.com/json-c_releases/releases/json-c-0.12.1.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz || wget -nc https://s3.amazonaws.com/json-c_releases/releases/json-c-0.12.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jsonc/json-c-0.12.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i s/-Werror// Makefile.in tests/Makefile.in &&
./configure --prefix=/usr --disable-static       &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "json-c=>`date`" | sudo tee -a $INSTALLED_LIST

