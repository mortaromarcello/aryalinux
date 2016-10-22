#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:alsa-firmware:1.0.29

#REQ:alsa-tools


cd $SOURCE_DIR

URL=http://alsa.cybermirror.org/firmware/alsa-firmware-1.0.29.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc ftp://ftp.alsa-project.org/pub/firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc http://alsa.cybermirror.org/firmware/alsa-firmware-1.0.29.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-firmware/alsa-firmware-1.0.29.tar.bz2

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
echo "alsa-firmware=>`date`" | sudo tee -a $INSTALLED_LIST

