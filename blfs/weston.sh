#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Weston is the referencebr3ak implementation of a Waylandbr3ak compositor, and a useful compositor in its own right. It hasbr3ak various backends that lets it run on Linux kernel modesetting andbr3ak evdev input as well as under X11. Weston also ships with a few example clients,br3ak from simple clients that demonstrate certain aspects of thebr3ak protocol to more complete clients and a simplistic toolkit.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cairo
#REQ:x7driver
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
#OPT:x7driver
#OPT:libwebp


#VER:weston:1.12.0


NAME="weston"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/weston/weston-1.12.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/weston/weston-1.12.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/weston/weston-1.12.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/weston/weston-1.12.0.tar.xz || wget -nc http://wayland.freedesktop.org/releases/weston-1.12.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/weston/weston-1.12.0.tar.xz


URL=http://wayland.freedesktop.org/releases/weston-1.12.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
