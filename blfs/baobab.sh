#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Baobab package contains abr3ak graphical directory tree analyzer.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:adwaita-icon-theme
#REQ:gtk3
#REQ:itstool
#REQ:vala


#VER:baobab:3.22.0


NAME="baobab"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/baobab/3.22/baobab-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/baobab/baobab-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/baobab/baobab-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/baobab/baobab-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/baobab/baobab-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/baobab/3.22/baobab-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/baobab/baobab-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/baobab/3.22/baobab-3.22.0.tar.xz
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
