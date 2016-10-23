#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Mutter is the window manager forbr3ak GNOME. It is not invoked directly,br3ak but from GNOME Session (on abr3ak machine with a hardware accelerated video driver).br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:clutter
#REQ:gnome-desktop
#REQ:libxkbcommon
#REQ:upower
#REQ:zenity
#REC:gobject-introspection
#REC:libcanberra
#REC:startup-notification
#REC:x7driver
#REC:wayland
#REC:wayland-protocols
#REC:xorg-server
#REC:cogl
#REC:clutter
#REC:gtk3


#VER:mutter:3.22.0


NAME="mutter"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/mutter/3.22/mutter-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mutter/mutter-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/mutter/3.22/mutter-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mutter/mutter-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mutter/mutter-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mutter/mutter-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mutter/mutter-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/mutter/3.22/mutter-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
