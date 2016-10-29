#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libxfce4ui package containsbr3ak GTK+ 2 widgets that are used bybr3ak other Xfce applications.br3ak"
SECTION="xfce"
VERSION=4.12.1
NAME="libxfce4ui"

#REQ:gtk2
#REQ:xfconf
#REC:gtk3
#REC:startup-notification
#OPT:gtk-doc
#OPT:perl-modules#perl-html-parser


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxfce4ui/libxfce4ui-4.12.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxfce4ui/libxfce4ui-4.12.1.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/libxfce4ui/4.12/libxfce4ui-4.12.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxfce4ui/libxfce4ui-4.12.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxfce4ui/libxfce4ui-4.12.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxfce4ui/libxfce4ui-4.12.1.tar.bz2


URL=http://archive.xfce.org/src/xfce/libxfce4ui/4.12/libxfce4ui-4.12.1.tar.bz2
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
