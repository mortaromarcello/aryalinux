#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The LXDE Common package provides abr3ak set of default configuration for LXDE.br3ak
#SECTION:lxde

whoami > /tmp/currentuser

#REQ:lxde-icon-theme
#REQ:lxpanel
#REQ:lxsession
#REQ:openbox
#REQ:pcmanfm
#REC:desktop-file-utils
#REC:hicolor-icon-theme
#REC:shared-mime-info
#REC:dbus
#OPT:notification-daemon
#OPT:xfce4-notifyd


#VER:lxde-common:0.99.1


NAME="lxde-common"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/lxde-common-0.99.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxde-common/lxde-common-0.99.1.tar.xz


URL=http://downloads.sourceforge.net/lxde/lxde-common-0.99.1.tar.xz
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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-mime-database /usr/share/mime &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&
update-desktop-database -q

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.xinitrc << "EOF"
ck-launch-session dbus-launch --exit-with-session startlxde
EOF
startx


startx &> ~/.x-session-errors




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
