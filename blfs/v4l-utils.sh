#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:v4l-utils:1.10.0

#REQ:glu
#REQ:libjpeg
#REQ:mesa
#OPT:alsa-lib
#OPT:qt5
#OPT:doxygen


cd $SOURCE_DIR

URL=https://www.linuxtv.org/downloads/v4l-utils/v4l-utils-1.10.0.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/v4l-utils/v4l-utils-1.10.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/v4l-utils/v4l-utils-1.10.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/v4l-utils/v4l-utils-1.10.0.tar.bz2 || wget -nc https://www.linuxtv.org/downloads/v4l-utils/v4l-utils-1.10.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/v4l-utils/v4l-utils-1.10.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/v4l-utils/v4l-utils-1.10.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "v4l-utils=>`date`" | sudo tee -a $INSTALLED_LIST

