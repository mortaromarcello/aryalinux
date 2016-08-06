#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:util-macros:1.19.0



cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/util/util-macros-1.19.0.tar.bz2

wget -nc http://ftp.x.org/pub/individual/util/util-macros-1.19.0.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/util/util-macros-1.19.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"


./configure $XORG_CONFIG



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "util-macros=>`date`" | sudo tee -a $INSTALLED_LIST
