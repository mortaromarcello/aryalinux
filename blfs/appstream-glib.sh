#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:appstream-glib:0.5.0

#REQ:gdk-pixbuf
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


cd $SOURCE_DIR

URL=http://people.freedesktop.org/~hughsient/appstream-glib/releases/appstream-glib-0.5.0.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/appstream-glib/appstream-glib-0.5.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/appstream-glib/appstream-glib-0.5.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/appstream-glib/appstream-glib-0.5.0.tar.xz || wget -nc http://people.freedesktop.org/~hughsient/appstream-glib/releases/appstream-glib-0.5.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/appstream-glib/appstream-glib-0.5.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/appstream-glib/appstream-glib-0.5.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
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
echo "appstream-glib=>`date`" | sudo tee -a $INSTALLED_LIST

