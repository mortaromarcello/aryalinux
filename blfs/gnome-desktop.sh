#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The GNOME Desktop package containsbr3ak a library that provides an API shared by several applications onbr3ak the GNOME Desktop.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="gnome-desktop"

#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:iso-codes
#REQ:itstool
#REQ:libxml2
#REQ:xkeyboard-config
#REC:gobject-introspection
#OPT:gtk-doc


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-desktop/gnome-desktop-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-desktop/gnome-desktop-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-desktop/3.22/gnome-desktop-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-desktop/3.22/gnome-desktop-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-desktop/gnome-desktop-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-desktop/gnome-desktop-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-desktop/gnome-desktop-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-desktop/3.22/gnome-desktop-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                 \
            --with-gnome-distributor="BLFS"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
