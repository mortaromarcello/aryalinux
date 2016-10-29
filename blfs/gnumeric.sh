#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Gnumeric package contains abr3ak spreadsheet program which is useful for mathematical analysis.br3ak"
SECTION="xsoft"
VERSION=1.12.32
NAME="gnumeric"

#REQ:goffice010
#REQ:rarian
#REC:adwaita-icon-theme
#REC:oxygen-icons5
#REC:gnome-icon-theme
#REC:yelp
#REC:xorg-server
#OPT:dconf
#OPT:gobject-introspection
#OPT:python-modules#pygobject3
#OPT:valgrind


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnumeric/gnumeric-1.12.32.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnumeric/gnumeric-1.12.32.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnumeric/gnumeric-1.12.32.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnumeric/gnumeric-1.12.32.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.32.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.32.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnumeric/gnumeric-1.12.32.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.32.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr  &&
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
