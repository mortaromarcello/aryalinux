#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libzeitgeist:0.3.18

#REQ:glib2
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://launchpad.net/libzeitgeist/0.3/0.3.18/+download/libzeitgeist-0.3.18.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc https://launchpad.net/libzeitgeist/0.3/0.3.18/+download/libzeitgeist-0.3.18.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i  "s|/doc/libzeitgeist|&-0.3.18|" Makefile.in &&
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
echo "libzeitgeist=>`date`" | sudo tee -a $INSTALLED_LIST

