#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:tree:1.7.0



cd $SOURCE_DIR

URL=http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc ftp://mama.indstate.edu/linux/tree/tree-1.7.0.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tree/tree-1.7.0.tgz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make MANDIR=/usr/share/man/man1 install &&
chmod -v 644 /usr/share/man/man1/tree.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "tree=>`date`" | sudo tee -a $INSTALLED_LIST

