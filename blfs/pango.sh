#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Pango is a library for laying outbr3ak and rendering of text, with an emphasis on internationalization. Itbr3ak can be used anywhere that text layout is needed, though most of thebr3ak work on Pango so far has been donebr3ak in the context of the GTK+ widgetbr3ak toolkit.br3ak"
SECTION="x"
VERSION=1.40.3
NAME="pango"

#REQ:fontconfig
#REQ:freetype2
#REQ:harfbuzz
#REQ:glib2
#REC:cairo
#REC:x7lib
#OPT:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pango/pango-1.40.3.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pango/pango-1.40.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pango/pango-1.40.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pango/pango-1.40.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pango/pango-1.40.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
