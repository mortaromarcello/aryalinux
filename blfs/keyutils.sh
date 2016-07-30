#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:keyutils:1.5.9



cd $SOURCE_DIR

URL=http://people.redhat.com/~dhowells/keyutils/keyutils-1.5.9.tar.bz2

wget -nc http://people.redhat.com/~dhowells/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make NO_ARLIB=1 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "keyutils=>`date`" | sudo tee -a $INSTALLED_LIST

