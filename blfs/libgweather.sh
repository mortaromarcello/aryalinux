#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libgweather package is abr3ak library used to access weather information from online services forbr3ak numerous locations.br3ak
#SECTION:gnome

#REQ:geocode-glib
#REQ:gtk3
#REQ:libsoup
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


#VER:libgweather:3.20.3


NAME="libgweather"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgweather/libgweather-3.20.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgweather/libgweather-3.20.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgweather/libgweather-3.20.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgweather/libgweather-3.20.3.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libgweather/3.20/libgweather-3.20.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgweather/libgweather-3.20.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgweather/3.20/libgweather-3.20.3.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libgweather/3.20/libgweather-3.20.3.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
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
