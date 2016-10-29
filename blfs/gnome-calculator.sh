#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak GNOME Calculator is a powerfulbr3ak graphical calculator with financial, logical and scientific modes.br3ak It uses a multiple precision package to do its arithmetic to give abr3ak high degree of accuracy.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="gnome-calculator"

#REQ:gtk3
#REQ:gtksourceview
#REQ:itstool
#REC:vala


wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-calculator/gnome-calculator-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-calculator/gnome-calculator-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.22/gnome-calculator-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-calculator/gnome-calculator-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-calculator/gnome-calculator-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.22/gnome-calculator-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-calculator/gnome-calculator-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.22/gnome-calculator-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
