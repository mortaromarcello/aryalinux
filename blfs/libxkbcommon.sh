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


cd $SOURCE_DIR

URL=http://xkbcommon.org/download/libxkbcommon-0.6.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://xkbcommon.org/download/libxkbcommon-0.6.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxkbcommon/libxkbcommon-0.6.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
