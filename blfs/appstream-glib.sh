#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Appstream-GLib packagebr3ak contains a library that provides GObjects and helper methods tobr3ak make it easy to read and write AppStream metadata. It also providesbr3ak a simple DOM implementation that makes it easy to edit nodes andbr3ak convert to and from the standardized XML representation.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:gdk-pixbuf
#REQ:json-glib
#REQ:libarchive
#REQ:libsoup
#REQ:pango
#REC:gcab
#REC:gobject-introspection
#REC:gtk3
#REC:yaml
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:gtk-doc


#VER:appstream-glib:0.6.3


NAME="appstream-glib"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/appstream-glib/appstream-glib-0.6.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/appstream-glib/appstream-glib-0.6.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/appstream-glib/appstream-glib-0.6.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/appstream-glib/appstream-glib-0.6.3.tar.xz || wget -nc http://people.freedesktop.org/~hughsient/appstream-glib/releases/appstream-glib-0.6.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/appstream-glib/appstream-glib-0.6.3.tar.xz


URL=http://people.freedesktop.org/~hughsient/appstream-glib/releases/appstream-glib-0.6.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
