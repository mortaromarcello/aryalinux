#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Totem PL Parser packagebr3ak contains a simple GObject-based library used to parse a host ofbr3ak playlist formats, as well as save those.br3ak
#SECTION:gnome

#REQ:gmime
#REQ:libsoup
#REC:gobject-introspection
#REC:libarchive
#REC:libgcrypt
#OPT:gtk-doc


#VER:totem-pl-parser:3.10.7


NAME="totem-pl-parser"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.7.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.10/totem-pl-parser-3.10.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.7.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.10/totem-pl-parser-3.10.7.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/totem-pl-parser/totem-pl-parser-3.10.7.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.10/totem-pl-parser-3.10.7.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
