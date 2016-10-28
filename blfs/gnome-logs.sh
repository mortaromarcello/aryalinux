#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME Logs package contains abr3ak log viewer for the systemd journal.br3ak
#SECTION:gnome

#REQ:gtk3
#REQ:gsettings-desktop-schemas
#REQ:itstool
#OPT:appstream-glib
#OPT:desktop-file-utils
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt


#VER:gnome-logs:3.22.0


NAME="gnome-logs"

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-logs/3.22/gnome-logs-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-logs/gnome-logs-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-logs/gnome-logs-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-logs/gnome-logs-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-logs/gnome-logs-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-logs/gnome-logs-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-logs/3.22/gnome-logs-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-logs/3.22/gnome-logs-3.22.0.tar.xz
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
