#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:hamlib:3.0.1

cd $SOURCE_DIR

wget -nc http://archive.ubuntu.com/ubuntu/pool/universe/h/hamlib/hamlib_3.0.1.orig.tar.gz

TARBALL="hamlib_3.0.1.orig.tar.gz"
DIRECTORY="hamlib-3.0.1"

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
echo "hamlib=>`date`" | sudo tee -a $INSTALLED_LIST

