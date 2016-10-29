#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak ATK provides the set ofbr3ak accessibility interfaces that are implemented by other toolkits andbr3ak applications. Using the ATKbr3ak interfaces, accessibility tools have full access to view andbr3ak control running applications.br3ak"
SECTION="x"
VERSION=2.22.0
NAME="atk"

#REQ:glib2
#REC:gobject-introspection
#OPT:gtk-doc


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/at/atk-2.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/at/atk-2.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/at/atk-2.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/atk/2.22/atk-2.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/atk/2.22/atk-2.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/at/atk-2.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/at/atk-2.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/atk/2.22/atk-2.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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
