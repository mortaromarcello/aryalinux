#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak IBus is an Intelligent Input Bus.br3ak It is a new input framework for Linux OS. It provides a fullbr3ak featured and user friendly input method user interface.br3ak"
SECTION="general"
VERSION=1.5.14
NAME="ibus"

#REQ:dconf
#REQ:iso-codes
#REC:gobject-introspection
#REC:gtk2
#REC:libnotify
#REC:vala
#OPT:python-modules#dbus-python
#OPT:python-modules#pygobject3
#OPT:gtk-doc
#OPT:python3
#OPT:python-modules#pyxdg
#OPT:libxkbcommon
#OPT:wayland


cd $SOURCE_DIR

URL=https://github.com/ibus/ibus/releases/download/1.5.14/ibus-1.5.14.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ibus/ibus-1.5.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ibus/ibus-1.5.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ibus/ibus-1.5.14.tar.gz || wget -nc https://github.com/ibus/ibus/releases/download/1.5.14/ibus-1.5.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ibus/ibus-1.5.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ibus/ibus-1.5.14.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --disable-emoji-dict      &&
make &&
sed -ri 's:"(/desktop):"/org/freedesktop\1:' data/ibus.schemas



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
