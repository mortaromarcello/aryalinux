#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Xfce4 Settings packagebr3ak contains a collection of programs that are useful for adjustingbr3ak your Xfce preferences.br3ak
#SECTION:xfce

#REQ:exo
#REQ:garcon
#REQ:libxfce4ui
#REQ:gnome-icon-theme
#REQ:lxde-icon-theme
#REC:libcanberra
#REC:libnotify
#REC:libxklavier
#OPT:x7driver


#VER:xfce4-settings:4.12.1


NAME="xfce4-settings"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-settings-4.12.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-settings-4.12.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-settings-4.12.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-settings-4.12.1.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/xfce4-settings/4.12/xfce4-settings-4.12.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-settings-4.12.1.tar.bz2


URL=http://archive.xfce.org/src/xfce/xfce4-settings/4.12/xfce4-settings-4.12.1.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
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
