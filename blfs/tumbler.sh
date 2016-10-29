#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Tumbler package contains abr3ak D-Bus thumbnailing service basedbr3ak on the thumbnail management D-Busbr3ak specification. This is useful for generating thumbnail images ofbr3ak files.br3ak"
SECTION="xfce"
VERSION=0.1.31
NAME="tumbler"

#REQ:dbus-glib
#OPT:curl
#OPT:freetype2
#OPT:gdk-pixbuf
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:libjpeg
#OPT:libgsf
#OPT:libpng
#OPT:poppler


wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/tumbler/0.1/tumbler-0.1.31.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2


URL=http://archive.xfce.org/src/xfce/tumbler/0.1/tumbler-0.1.31.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
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
