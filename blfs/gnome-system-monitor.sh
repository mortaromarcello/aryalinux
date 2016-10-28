#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME System Monitor packagebr3ak contains GNOME's replacement forbr3ak <span class="command"><strong>gtop</strong>.br3ak
#SECTION:gnome

#REQ:adwaita-icon-theme
#REQ:appstream-glib
#REQ:gtkmm3
#REQ:itstool
#REQ:libgtop
#REQ:librsvg
#REC:libwnck
#OPT:desktop-file-utils


#VER:gnome-system-monitor:3.22.0


NAME="gnome-system-monitor"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-system-monitor/gnome-system-monitor-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-system-monitor/3.22/gnome-system-monitor-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-system-monitor/gnome-system-monitor-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-system-monitor/3.22/gnome-system-monitor-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-system-monitor/gnome-system-monitor-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-system-monitor/gnome-system-monitor-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-system-monitor/gnome-system-monitor-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-system-monitor/3.22/gnome-system-monitor-3.22.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr    \
            --enable-wnck    \
            --enable-systemd &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
