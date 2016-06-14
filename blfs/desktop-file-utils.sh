#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:desktop-file-utils:0.22

#REQ:glib2
#OPT:emacs


cd $SOURCE_DIR

URL=http://freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.22.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.22.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.22.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.22.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.22.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.22.tar.xz || wget -nc http://freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.22.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
echo "desktop-file-utils=>`date`" | sudo tee -a $INSTALLED_LIST

