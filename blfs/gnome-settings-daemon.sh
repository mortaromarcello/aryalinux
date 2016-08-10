#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-settings-daemon:3.20.1

#REQ:colord
#REQ:geoclue2
#REQ:gnome-desktop
#REQ:lcms2
#REQ:libcanberra
#REQ:libgweather
#REQ:libnotify
#REQ:librsvg
#REQ:libwacom
#REQ:pulseaudio
#REQ:upower
#REQ:x7driver
#REC:cups
#REC:networkmanager
#REC:nss
#REC:wayland


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.20/gnome-settings-daemon-3.20.1.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.20.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.20/gnome-settings-daemon-3.20.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.20.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.20.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.20/gnome-settings-daemon-3.20.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.20.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-settings-daemon/gnome-settings-daemon-3.20.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make udevrulesdir=/lib/udev/rules.d install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gnome-settings-daemon=>`date`" | sudo tee -a $INSTALLED_LIST

