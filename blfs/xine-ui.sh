#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xine-ui:0.99.9

#REQ:xine-lib
#REQ:shared-mime-info
#OPT:curl
#OPT:aalib


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/xine/xine-ui-0.99.9.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://downloads.sourceforge.net/xine/xine-ui-0.99.9.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docsdir=/usr/share/doc/xine-ui-0.99.9 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xine-ui=>`date`" | sudo tee -a $INSTALLED_LIST

