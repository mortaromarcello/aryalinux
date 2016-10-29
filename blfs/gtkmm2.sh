#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Gtkmm package provides a C++br3ak interface to GTK+ 2. It can bebr3ak installed alongside <a class="xref" href="gtkmm3.html" title="Gtkmm-3.22.0">Gtkmm-3.22.0</a> (the GTK+br3ak 3 version) with no namespace conflicts.br3ak"
SECTION="x"
VERSION=2.24.5
NAME="gtkmm2"

#REQ:atkmm
#REQ:gtk2
#REQ:pangomm


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtkmm/gtkmm-2.24.5.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/^libdocdir =/ s/$(book_name)/gtkmm-2.24.5/' \
    -i docs/Makefile.in


CXXFLAGS="-g -O2 -std=c++11" ./configure --prefix=/usr &&
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
