#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libxslt:1.1.29

#REQ:libxml2
#REC:docbook
#REC:docbook-xsl
#OPT:libgcrypt
#OPT:python2


cd $SOURCE_DIR

URL=http://xmlsoft.org/sources/libxslt-1.1.29.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz || wget -nc http://xmlsoft.org/sources/libxslt-1.1.29.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz || wget -nc ftp://xmlsoft.org/libxslt/libxslt-1.1.29.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
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
echo "libxslt=>`date`" | sudo tee -a $INSTALLED_LIST

