#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak GeoClue is a modularbr3ak geoinformation service built on top of the D-Bus messaging system. The goal of thebr3ak GeoClue project is to makebr3ak creating location-aware applications as simple as possible.br3ak
#SECTION:basicnet

#REQ:json-glib
#REQ:libsoup
#REC:ModemManager
#OPT:libnotify


#VER:geoclue:2.4.4


NAME="geoclue2"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/geoclue/geoclue-2.4.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/geoclue/geoclue-2.4.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/geoclue/geoclue-2.4.4.tar.xz || wget -nc http://www.freedesktop.org/software/geoclue/releases/2.4/geoclue-2.4.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/geoclue/geoclue-2.4.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/geoclue/geoclue-2.4.4.tar.xz


URL=http://www.freedesktop.org/software/geoclue/releases/2.4/geoclue-2.4.4.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
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
