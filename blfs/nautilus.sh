#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Nautilus package contains thebr3ak GNOME file manager.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="nautilus"

#REQ:gnome-autoar
#REQ:gnome-desktop
#REQ:libnotify
#REC:exempi
#REC:gobject-introspection
#REC:libexif
#REC:adwaita-icon-theme
#REC:gvfs
#OPT:gtk-doc


wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nautilus/nautilus-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/nautilus/3.22/nautilus-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nautilus/nautilus-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nautilus/nautilus-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nautilus/nautilus-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nautilus/nautilus-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/nautilus/3.22/nautilus-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/nautilus/3.22/nautilus-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-selinux    \
            --disable-tracker    \
            --disable-packagekit &&
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
