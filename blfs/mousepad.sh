#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Mousepad is a simple GTK+ 2 text editor for the Xfce desktop environment.br3ak"
SECTION="xfce"
VERSION=0.4.0
NAME="mousepad"

#REQ:gtksourceview
#OPT:dconf
#OPT:dbus-glib


wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mousepad/mousepad-0.4.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mousepad/mousepad-0.4.0.tar.bz2 || wget -nc http://archive.xfce.org/src/apps/mousepad/0.4/mousepad-0.4.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mousepad/mousepad-0.4.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mousepad/mousepad-0.4.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mousepad/mousepad-0.4.0.tar.bz2


URL=http://archive.xfce.org/src/apps/mousepad/0.4/mousepad-0.4.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --enable-keyfile-settings &&
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
