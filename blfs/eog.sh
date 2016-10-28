#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak EOG is an application used forbr3ak viewing and cataloging image files on the GNOME Desktop. It has basic editingbr3ak capabilites.br3ak
#SECTION:gnome

#REQ:adwaita-icon-theme
#REQ:gnome-desktop
#REQ:itstool
#REQ:libpeas
#REQ:shared-mime-info
#REC:gobject-introspection
#REC:librsvg
#OPT:exempi
#OPT:gtk-doc
#OPT:lcms2
#OPT:libexif


#VER:eog:3.20.4


NAME="eog"

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/eog/3.20/eog-3.20.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/eog/eog-3.20.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/eog/eog-3.20.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/eog/eog-3.20.4.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/eog/3.20/eog-3.20.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/eog/eog-3.20.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/eog/eog-3.20.4.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/eog/3.20/eog-3.20.4.tar.xz
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
