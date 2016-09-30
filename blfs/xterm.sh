#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xterm:325

#REQ:x7app
#OPT:valgrind


cd $SOURCE_DIR

URL=ftp://invisible-island.net/xterm/xterm-325.tgz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xterm/xterm-325.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xterm/xterm-325.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xterm/xterm-325.tgz || wget -nc ftp://invisible-island.net/xterm/xterm-325.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xterm/xterm-325.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xterm/xterm-325.tgz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap &&
printf '\tkbs=\\177,\n' >> terminfo &&
TERMINFO=/usr/share/terminfo \
./configure $XORG_CONFIG     \
    --with-app-defaults=/etc/X11/app-defaults &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
make install-ti

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/X11/app-defaults/XTerm << "EOF"
*VT100*locale: true
*VT100*faceName: Monospace
*VT100*faceSize: 10
*backarrowKeyIsErase: true
*ptyInitialErase: true
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xterm=>`date`" | sudo tee -a $INSTALLED_LIST

