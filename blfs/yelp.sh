#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Yelp package contains a helpbr3ak browser used for viewing help files.br3ak
#SECTION:gnome

#REQ:gsettings-desktop-schemas
#REQ:webkitgtk
#REQ:yelp-xsl
#REC:desktop-file-utils
#OPT:gtk-doc


#VER:yelp:3.22.0


NAME="yelp"

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/yelp/3.22/yelp-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/yelp/3.22/yelp-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/yelp/3.22/yelp-3.22.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
update-desktop-database
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
