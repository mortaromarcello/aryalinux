#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak libxkbcommon is a keymap compilerbr3ak and support library which processes a reduced subset of keymaps asbr3ak defined by the XKB specification.br3ak"
SECTION="general"
VERSION=0.6.1
NAME="libxkbcommon"

#REQ:xkeyboard-config
#REC:libxcb


wget -nc http://xkbcommon.org/download/libxkbcommon-0.6.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz


URL=http://xkbcommon.org/download/libxkbcommon-0.6.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG     \
            --docdir=/usr/share/doc/libxkbcommon-0.6.1 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
