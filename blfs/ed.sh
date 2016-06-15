#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions


#REQ:libarchive


cd $SOURCE_DIR

whoami > /tmp/currentuser

./configure --prefix=/usr --bindir=/bin &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "ed=>`date`" | sudo tee -a $INSTALLED_LIST

