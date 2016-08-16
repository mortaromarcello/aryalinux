#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:asciidoc:8.6.9

#REQ:python2
#REQ:python3


cd $SOURCE_DIR

URL=http://sourceforge.net/projects/asciidoc/files/asciidoc/8.6.9/asciidoc-8.6.9.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz || wget -nc http://sourceforge.net/projects/asciidoc/files/asciidoc/8.6.9/asciidoc-8.6.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/asciidoc/asciidoc-8.6.9.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "asciidoc=>`date`" | sudo tee -a $INSTALLED_LIST

