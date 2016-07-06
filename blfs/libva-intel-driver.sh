#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libva-intel-driver:1.6.2

#REQ:libva
#OPT:wayland
#OPT:libva


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/libva-intel-driver-1.6.2.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.6.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-intel-driver-1.6.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-intel-driver-1.6.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.6.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-intel-driver-1.6.2.tar.bz2 || wget -nc http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/libva-intel-driver-1.6.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libva-intel-driver=>`date`" | sudo tee -a $INSTALLED_LIST

