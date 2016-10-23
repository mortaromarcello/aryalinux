#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME Shell Extensions packagebr3ak contains a collection of extensions providing additional andbr3ak optional functionality to the GNOMEbr3ak Shell.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:libgtop


#VER:gnome-shell-extensions:3.22.0


NAME="gnome-shell-extensions"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-shell-extensions/gnome-shell-extensions-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-shell-extensions/gnome-shell-extensions-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-shell-extensions/3.22/gnome-shell-extensions-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-shell-extensions/gnome-shell-extensions-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-shell-extensions/3.22/gnome-shell-extensions-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-shell-extensions/gnome-shell-extensions-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-shell-extensions/gnome-shell-extensions-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-shell-extensions/3.22/gnome-shell-extensions-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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
