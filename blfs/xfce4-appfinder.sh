#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Xfce4 Appfinder is a tool to findbr3ak and launch installed applications by searching the .desktop filesbr3ak installed on your system.br3ak
#SECTION:xfce

#REQ:garcon
#REQ:libxfce4ui


#VER:xfce4-appfinder:4.12.0


NAME="xfce4-appfinder"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-appfinder-4.12.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-appfinder-4.12.0.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/xfce4-appfinder/4.12/xfce4-appfinder-4.12.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-appfinder-4.12.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-appfinder-4.12.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-appfinder-4.12.0.tar.bz2


URL=http://archive.xfce.org/src/xfce/xfce4-appfinder/4.12/xfce4-appfinder-4.12.0.tar.bz2
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
