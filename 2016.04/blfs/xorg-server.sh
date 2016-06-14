#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xorg-server:1.18.2

#REQ:nettle
#REQ:libgcrypt
#REQ:openssl
#REQ:libpciaccess
#REQ:pixman
#REQ:x7font
#REQ:xkeyboard-config
#REC:libepoxy
#REC:wayland
#REC:systemd
#REC:xcb-util-keysyms
#OPT:acpid
#OPT:doxygen
#OPT:fop
#OPT:gs
#OPT:xcb-util-keysyms
#OPT:xcb-util-image
#OPT:xcb-util-renderutil
#OPT:xcb-util-wm
#OPT:xmlto


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/xserver/xorg-server-1.18.2.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.18.2.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/xserver/xorg-server-1.18.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.18.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.18.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.18.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Xorg/xorg-server-1.18.2.tar.bz2 || wget -nc http://ftp.x.org/pub/individual/xserver/xorg-server-1.18.2.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/downloads/xorg-server/xorg-server-1.18.2-add_prime_support-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xorg-server-1.18.2-add_prime_support-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG         \
           --enable-glamor       \
           --enable-suid-wrapper \
           --with-xkb-output=/var/lib/xkb &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /etc/X11/xorg.conf.d

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xorg-server=>`date`" | sudo tee -a $INSTALLED_LIST

