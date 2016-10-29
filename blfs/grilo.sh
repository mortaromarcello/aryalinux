#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Grilo is a framework focused onbr3ak making media discovery and browsing easy for applications andbr3ak application developers.br3ak"
SECTION="gnome"
VERSION=0.3.2
NAME="grilo"

#REQ:glib2
#REQ:libxml2
#REC:gobject-introspection
#REC:gtk3
#REC:libsoup
#REC:totem-pl-parser
#REC:vala
#OPT:avahi
#OPT:docbook-utils
#OPT:liboauth
#OPT:gtk-doc


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/grilo/grilo-0.3.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/grilo/grilo-0.3.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/grilo/grilo-0.3.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/grilo/grilo-0.3.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/grilo/grilo-0.3.2.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --libdir=/usr/lib \
            --disable-static &&
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
