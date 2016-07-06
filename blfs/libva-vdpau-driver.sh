#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libva-vdpau-driver:0.7.4

#REQ:libva
#REQ:libvdpau


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/libva-vdpau-driver-0.7.4.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/downloads/libva-vdpau-driver/libva-vdpau-driver-0.7.4-build_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libva-vdpau-driver-0.7.4-build_fixes-1.patch
wget -nc http://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/libva-vdpau-driver-0.7.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-vdpau-driver-0.7.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-vdpau-driver-0.7.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-vdpau-driver-0.7.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-vdpau-driver-0.7.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-vdpau-driver-0.7.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../libva-vdpau-driver-0.7.4-build_fixes-1.patch &&
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
echo "libva-vdpau-driver=>`date`" | sudo tee -a $INSTALLED_LIST

