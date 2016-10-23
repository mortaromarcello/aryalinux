#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Xfce4 Panel package containsbr3ak the Xfce4 Panel.br3ak
#SECTION:xfce

whoami > /tmp/currentuser

#REQ:exo
#REQ:garcon
#REQ:libwnck2
#REQ:libxfce4ui
#OPT:gtk-doc


#VER:xfce4-panel:4.12.0


NAME="xfce4-panel"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-panel-4.12.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-panel-4.12.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-panel-4.12.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-panel-4.12.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-panel-4.12.0.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/xfce4-panel/4.12/xfce4-panel-4.12.0.tar.bz2


URL=http://archive.xfce.org/src/xfce/xfce4-panel/4.12/xfce4-panel-4.12.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc --enable-gtk3 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
