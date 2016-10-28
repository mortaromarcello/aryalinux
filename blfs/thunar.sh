#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Thunar is the Xfce file manager, a GTK+ 2 GUI to organise the files on yourbr3ak computer.br3ak
#SECTION:xfce

#REQ:exo
#REQ:libxfce4ui
#REQ:gnome-icon-theme
#REQ:lxde-icon-theme
#REC:libgudev
#REC:libnotify
#REC:xfce4-panel
#OPT:gvfs
#OPT:libexif
#OPT:tumbler


#VER:Thunar:1.6.10


NAME="thunar"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunar/Thunar-1.6.10.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/thunar/Thunar-1.6.10.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/thunar/Thunar-1.6.10.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/thunar/1.6/Thunar-1.6.10.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/thunar/Thunar-1.6.10.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/thunar/Thunar-1.6.10.tar.bz2


URL=http://archive.xfce.org/src/xfce/thunar/1.6/Thunar-1.6.10.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/Thunar-1.6.10 &&
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
