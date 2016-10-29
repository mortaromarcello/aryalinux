#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The GNOME Power Manager packagebr3ak contains a tool used to report on power management on the system.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="gnome-power-manager"

#REQ:appstream-glib
#REQ:gtk3
#REQ:upower
#OPT:docbook-utils


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-power-manager/gnome-power-manager-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-power-manager/gnome-power-manager-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-power-manager/gnome-power-manager-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-power-manager/3.22/gnome-power-manager-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-power-manager/3.22/gnome-power-manager-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-power-manager/gnome-power-manager-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-power-manager/gnome-power-manager-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-power-manager/3.22/gnome-power-manager-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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
