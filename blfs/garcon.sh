#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Garcon package contains abr3ak freedesktop.org compliant menu implementation based on GLib and GIO.br3ak
#SECTION:xfce

whoami > /tmp/currentuser

#REQ:libxfce4ui
#REQ:gtk2
#REQ:gtk3
#OPT:gtk-doc


#VER:garcon:0.5.0


NAME="garcon"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/garcon/garcon-0.5.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/garcon/garcon-0.5.0.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/garcon/0.5/garcon-0.5.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/garcon/garcon-0.5.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/garcon/garcon-0.5.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/garcon/garcon-0.5.0.tar.bz2


URL=http://archive.xfce.org/src/xfce/garcon/0.5/garcon-0.5.0.tar.bz2
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




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
