#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The GNOME Session package containsbr3ak the GNOME session manager.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="gnome-session"

#REQ:dbus-glib
#REQ:gnome-desktop
#REQ:json-glib
#REQ:mesa
#REQ:upower
#REQ:systemd
#OPT:GConf
#OPT:xmlto
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-session/3.22/gnome-session-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-session/gnome-session-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-session/gnome-session-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-session/gnome-session-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-session/3.22/gnome-session-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-session/gnome-session-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-session/gnome-session-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-session/3.22/gnome-session-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --docdir=/usr/share/doc/gnome-session-3.22.0 &&
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
