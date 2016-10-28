#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Thunar Volume Manager is anbr3ak extension for the Thunar filebr3ak manager, which enables automatic management of removable drives andbr3ak media.br3ak
#SECTION:xfce

#REQ:exo
#REQ:libgudev
#REQ:libxfce4ui
#REC:libnotify
#REC:startup-notification
#OPT:gvfs
#OPT:polkit-gnome


#VER:thunar-volman:0.8.1


NAME="thunar-volman"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunar/thunar-volman-0.8.1.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/thunar-volman/0.8/thunar-volman-0.8.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunar/thunar-volman-0.8.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/thunar/thunar-volman-0.8.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/thunar/thunar-volman-0.8.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/thunar/thunar-volman-0.8.1.tar.bz2


URL=http://archive.xfce.org/src/xfce/thunar-volman/0.8/thunar-volman-0.8.1.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
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
