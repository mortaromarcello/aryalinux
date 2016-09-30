#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-shell:3.20.4

#REQ:caribou
#REQ:evolution-data-server
#REQ:gjs
#REQ:gnome-control-center
#REQ:libcroco
#REQ:mutter
#REQ:startup-notification
#REQ:adwaita-icon-theme
#REQ:dconf
#REQ:gdm
#REQ:gnome-backgrounds
#REQ:gnome-menus
#REQ:gnome-themes-standard
#REQ:telepathy-mission-control
#REC:gnome-bluetooth
#REC:gst10-plugins-base
#REC:network-manager-applet
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.20/gnome-shell-3.20.4.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-shell/gnome-shell-3.20.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-shell/gnome-shell-3.20.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-shell/gnome-shell-3.20.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-shell/gnome-shell-3.20.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-shell/gnome-shell-3.20.4.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.20/gnome-shell-3.20.4.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.20/gnome-shell-3.20.4.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gnome-shell=>`date`" | sudo tee -a $INSTALLED_LIST

