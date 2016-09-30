#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:weston:1.11.0

#REQ:cairo
#REQ:x7driver#libinput
#REQ:libjpeg
#REQ:libxkbcommon
#REQ:mesa
#REQ:mtdev
#REQ:wayland
#REQ:wayland-protocols
#REC:glu
#REC:linux-pam
#REC:pango
#REC:systemd
#REC:x7lib
#REC:xorg-server
#OPT:colord
#OPT:doxygen
#OPT:lcms2
#OPT:libpng
#OPT:x7driver#libva
#OPT:libwebp


cd $SOURCE_DIR

URL=http://wayland.freedesktop.org/releases/weston-1.11.0.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/weston/weston-1.11.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/weston/weston-1.11.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/weston/weston-1.11.0.tar.xz || wget -nc http://wayland.freedesktop.org/releases/weston-1.11.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/weston/weston-1.11.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/weston/weston-1.11.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --enable-demo-clients-install &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


weston


weston-launch


weston-launch -- --backend=fbdev-backend.so


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "weston=>`date`" | sudo tee -a $INSTALLED_LIST

