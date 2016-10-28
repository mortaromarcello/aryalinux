#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME Terminal packagebr3ak contains the terminal emulator for GNOME Desktop.br3ak
#SECTION:gnome

#REQ:appstream-glib
#REQ:dconf
#REQ:gnome-shell
#REQ:gsettings-desktop-schemas
#REQ:itstool
#REQ:pcre2
#REQ:vte
#REC:nautilus
#OPT:desktop-file-utils


#VER:gnome-terminal:3.22.0


NAME="gnome-terminal"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-terminal/gnome-terminal-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-terminal/gnome-terminal-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-terminal/gnome-terminal-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-terminal/gnome-terminal-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-terminal/gnome-terminal-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-terminal/3.22/gnome-terminal-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-terminal/3.22/gnome-terminal-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-terminal/3.22/gnome-terminal-3.22.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr       \
            --disable-migration \
            --disable-static    &&
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
