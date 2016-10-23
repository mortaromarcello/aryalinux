#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME Themes Standard packagebr3ak contains various components of the default GNOME theme.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:gtk2
#REQ:gtk3
#REQ:librsvg


#VER:gnome-themes-standard:3.22.2


NAME="gnome-themes-standard"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-themes/gnome-themes-standard-3.22.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.2.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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
