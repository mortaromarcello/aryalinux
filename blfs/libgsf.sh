#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libgsf package contains abr3ak library used for providing an extensible input/output abstractionbr3ak layer for structured file formats.br3ak"
SECTION="general"
VERSION=1.14.40
NAME="libgsf"

#REQ:glib2
#REQ:libxml2
#REC:gdk-pixbuf
#OPT:gobject-introspection
#OPT:gtk-doc


wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.40.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.40.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.40.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
