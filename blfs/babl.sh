#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Babl package is a dynamic, anybr3ak to any, pixel format translation library.br3ak"
SECTION="general"
VERSION=0.1.18
NAME="babl"

#OPT:gobject-introspection


wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/babl/babl-0.1.18.tar.bz2 || wget -nc http://download.gimp.org/pub/babl/0.1/babl-0.1.18.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/babl/babl-0.1.18.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/babl/babl-0.1.18.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/babl/babl-0.1.18.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/babl/babl-0.1.18.tar.bz2


URL=http://download.gimp.org/pub/babl/0.1/babl-0.1.18.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-docs &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/gtk-doc/html/babl/graphics &&
install -v -m644 docs/*.{css,html} /usr/share/gtk-doc/html/babl &&
install -v -m644 docs/graphics/*.{html,png,svg} /usr/share/gtk-doc/html/babl/graphics

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
