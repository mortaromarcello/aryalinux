#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Notification Daemon packagebr3ak contains a daemon that displays passive pop-up notifications.br3ak
#SECTION:gnome

#REQ:gtk3
#REQ:libcanberra


#VER:notification-daemon:3.20.0


NAME="notification-daemon"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/notification-daemon/notification-daemon-3.20.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


pgrep -l notification-da &&
notify-send -i info Information "Hi ${USER}, This is a Test"



cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
