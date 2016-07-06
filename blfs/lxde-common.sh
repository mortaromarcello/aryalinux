#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lxde-common:0.99.1

#REQ:lxde-icon-theme
#REQ:lxpanel
#REQ:lxsession
#REQ:openbox
#REQ:pcmanfm
#REQ:systemd
#REC:desktop-file-utils
#REC:hicolor-icon-theme
#REC:shared-mime-info
#OPT:dbus
#OPT:notification-daemon
#OPT:xfce4-notifyd


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lxde/lxde-common-0.99.1.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/lxde-common-0.99.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-mime-database /usr/share/mime &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&
update-desktop-database -q

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.xinitrc << "EOF"
startlxde
EOF
startx


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "lxde-common=>`date`" | sudo tee -a $INSTALLED_LIST

