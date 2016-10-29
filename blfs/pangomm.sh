#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Pangomm package provides a C++br3ak interface to Pango.br3ak"
SECTION="x"
VERSION=2.40.1
NAME="pangomm"

#REQ:cairomm
#REQ:glibmm
#REQ:pango


wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pango/pangomm-2.40.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pango/pangomm-2.40.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/pangomm/2.40/pangomm-2.40.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pango/pangomm-2.40.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pango/pangomm-2.40.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pango/pangomm-2.40.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pangomm/2.40/pangomm-2.40.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/pangomm/2.40/pangomm-2.40.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/^libdocdir =/ s/$(book_name)/pangomm-2.40.1/' \
    -i docs/Makefile.in


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
