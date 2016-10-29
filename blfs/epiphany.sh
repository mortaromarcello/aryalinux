#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Epiphany is a simple yet powerfulbr3ak GNOME web browser targeted atbr3ak non-technical users. Its principles are simplicity and standardsbr3ak compliance.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="epiphany"

#REQ:avahi
#REQ:gcr
#REQ:gnome-desktop
#REQ:libnotify
#REQ:libwnck
#REQ:webkitgtk
#REC:nss
#OPT:lsb-release
#OPT:gnome-keyring
#OPT:seahorse


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/epiphany/epiphany-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/epiphany/epiphany-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/epiphany/3.22/epiphany-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/epiphany/epiphany-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/epiphany/epiphany-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/epiphany/3.22/epiphany-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/epiphany/epiphany-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/epiphany/3.22/epiphany-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


make -k check



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
