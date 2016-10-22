#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:unrarsrc:5.4.5



cd $SOURCE_DIR

URL=http://www.rarlab.com/rar/unrarsrc-5.4.5.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz || wget -nc http://www.rarlab.com/rar/unrarsrc-5.4.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make -f makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 unrar /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "unrar=>`date`" | sudo tee -a $INSTALLED_LIST

