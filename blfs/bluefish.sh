#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:bluefish:2.2.7

#REQ:gtk2
#REQ:gtk3
#OPT:enchant
#OPT:gucharmap
#OPT:pcre


cd $SOURCE_DIR

URL=http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.7.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluefish/bluefish-2.2.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bluefish/bluefish-2.2.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluefish/bluefish-2.2.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bluefish/bluefish-2.2.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bluefish/bluefish-2.2.7.tar.bz2 || wget -nc http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.7.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --docdir=/usr/share/doc/bluefish-2.2.7 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "bluefish=>`date`" | sudo tee -a $INSTALLED_LIST

