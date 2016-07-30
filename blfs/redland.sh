#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:redland:1.0.17

#REQ:rasqal
#OPT:db
#OPT:libiodbc
#OPT:sqlite
#OPT:mariadb
#OPT:postgresql


cd $SOURCE_DIR

URL=http://download.librdf.org/source/redland-1.0.17.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/redland/redland-1.0.17.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/redland/redland-1.0.17.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/redland/redland-1.0.17.tar.gz || wget -nc http://download.librdf.org/source/redland-1.0.17.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/redland/redland-1.0.17.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/redland/redland-1.0.17.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "redland=>`date`" | sudo tee -a $INSTALLED_LIST

