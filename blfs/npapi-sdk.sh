#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:npapi-sdk:0.27.2



cd $SOURCE_DIR

URL=https://bitbucket.org/mgorny/npapi-sdk/downloads/npapi-sdk-0.27.2.tar.bz2

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc https://bitbucket.org/mgorny/npapi-sdk/downloads/npapi-sdk-0.27.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "npapi-sdk=>`date`" | sudo tee -a $INSTALLED_LIST

