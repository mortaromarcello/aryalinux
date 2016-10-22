#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xkeyboard-config:2.19

#REQ:x7lib


cd $SOURCE_DIR

URL=http://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.19.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc http://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG --with-xkb-rules-symlink=xorg &&
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

