#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Redland is a set of free softwarebr3ak C libraries that provide support for the Resource Descriptionbr3ak Framework (RDF).br3ak"
SECTION="general"
VERSION=1.0.17
NAME="redland"

#REQ:rasqal
#OPT:db
#OPT:libiodbc
#OPT:sqlite
#OPT:mariadb
#OPT:postgresql


cd $SOURCE_DIR

URL=http://download.librdf.org/source/redland-1.0.17.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/redland/redland-1.0.17.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/redland/redland-1.0.17.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/redland/redland-1.0.17.tar.gz || wget -nc http://download.librdf.org/source/redland-1.0.17.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/redland/redland-1.0.17.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/redland/redland-1.0.17.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
