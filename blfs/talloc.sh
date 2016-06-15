#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:talloc:2.1.6

#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:python2
#OPT:python3


cd $SOURCE_DIR

URL=https://www.samba.org/ftp/talloc/talloc-2.1.6.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/talloc/talloc-2.1.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/talloc/talloc-2.1.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/talloc/talloc-2.1.6.tar.gz || wget -nc https://www.samba.org/ftp/talloc/talloc-2.1.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/talloc/talloc-2.1.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/talloc/talloc-2.1.6.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "talloc=>`date`" | sudo tee -a $INSTALLED_LIST

