#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xkeyboard-config:2.17

#REQ:libxslt
#OPT:x7proto
#OPT:x7lib


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.17.tar.bz2

wget -nc ftp://ftp.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.17.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.17.tar.bz2 || wget -nc http://ftp.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.17.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.17.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.17.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.17.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.17.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr          \
            --disable-runtime-deps \
            --with-xkb-rules-symlink=xorg &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xkeyboard-config=>`date`" | sudo tee -a $INSTALLED_LIST

