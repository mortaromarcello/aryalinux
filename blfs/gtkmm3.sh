#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Gtkmm package provides a C++br3ak interface to GTK+ 3.br3ak
#SECTION:x

#REQ:atkmm
#REQ:gtk3
#REQ:pangomm


#VER:gtkmm:3.22.0


NAME="gtkmm3"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkmm/gtkmm-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtkmm/gtkmm-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtkmm/gtkmm-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkmm/3.22/gtkmm-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkmm/gtkmm-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtkmm/gtkmm-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtkmm/3.22/gtkmm-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gtkmm/3.22/gtkmm-3.22.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -e '/^libdocdir =/ s/$(book_name)/gtkmm-3.22.0/' \
    -i docs/Makefile.in

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
