#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:sharutils:4.15.2



cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz

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
echo "sharutils=>`date`" | sudo tee -a $INSTALLED_LIST

