#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Xorg Server is the core of thebr3ak X Window system.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:openssl
#REQ:nettle
#REQ:libgcrypt
#REQ:pixman
#REQ:x7font
#REQ:xkeyboard-config
#REC:libepoxy
#REC:wayland
#REC:systemd
#OPT:acpid
#OPT:doxygen
#OPT:fop
#OPT:gs
#OPT:xcb-util-keysyms
#OPT:xcb-util-image
#OPT:xcb-util-renderutil
#OPT:xcb-util-wm
#OPT:xmlto


#VER:xorg-server:1.18.4


NAME="xorg-server"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.x.org/pub/individual/xserver/xorg-server-1.18.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.18.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.18.4.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/xserver/xorg-server-1.18.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.18.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Xorg/xorg-server-1.18.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.18.4.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/downloads/xorg-server/xorg-server-1.18.4-add_prime_support-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xorg-server-1.18.4-add_prime_support-1.patch


URL=http://ftp.x.org/pub/individual/xserver/xorg-server-1.18.4.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../xorg-server-1.18.4-add_prime_support-1.patch


./configure $XORG_CONFIG          \
            --enable-glamor       \
            --enable-suid-wrapper \
            --with-xkb-output=/var/lib/xkb &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /etc/X11/xorg.conf.d

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
