#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Xorg Server is the core of thebr3ak X Window system.br3ak"
SECTION="x"
VERSION=1.19.0
NAME="xorg-server"

#REQ:openssl
#REQ:nettle
#REQ:libgcrypt
#REQ:pixman
#REQ:x7font
#REQ:xkeyboard-config
#REC:libepoxy
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

URL=http://ftp.x.org/pub/individual/xserver/xorg-server-1.19.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.x.org/pub/individual/xserver/xorg-server-1.19.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.19.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.19.0.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/xserver/xorg-server-1.19.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.19.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Xorg/xorg-server-1.19.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.19.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/downloads/xorg-server/xorg-server-1.19.0-add_prime_support-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xorg-server-1.19.0-add_prime_support-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../xorg-server-1.19.0-add_prime_support-1.patch


./configure $XORG_CONFIG             \
            --enable-glamor          \
            --enable-install-setuid  \
            --enable-suid-wrapper    \
            --disable-systemd-logind \
            --with-xkb-output=/var/lib/xkb &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /etc/X11/xorg.conf.d
cat >> /etc/sysconfig/createfiles << "EOF"
/tmp/.ICE-unix dir 1777 root root
/tmp/.X11-unix dir 1777 root root
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
