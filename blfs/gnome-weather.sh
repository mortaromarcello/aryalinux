#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak GNOME Weather is a smallbr3ak application that allows you to monitor the current weatherbr3ak conditions for your city, or anywhere in the world, and to accessbr3ak updated forecasts provided by various internet services.br3ak
#SECTION:gnome

#REQ:gjs
#REQ:libgweather
#OPT:appstream-glib


#VER:gnome-weather:3.20.2


NAME="gnome-weather"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-weather/gnome-weather-3.20.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-weather/gnome-weather-3.20.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-weather/gnome-weather-3.20.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-weather/3.20/gnome-weather-3.20.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-weather/gnome-weather-3.20.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-weather/gnome-weather-3.20.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-weather/3.20/gnome-weather-3.20.2.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-weather/3.20/gnome-weather-3.20.2.tar.xz
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
