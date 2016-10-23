#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak GNOME Color Manager is a sessionbr3ak framework for the GNOME desktopbr3ak environment that makes it easy to manage, install and generatebr3ak color profiles.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:colord-gtk
#REQ:colord1
#REQ:gtk3
#REQ:itstool
#REQ:lcms2
#REQ:libcanberra
#REQ:libexif
#REC:appstream-glib
#REC:exiv2
#REC:vte
#OPT:docbook-utils


#VER:gnome-color-manager:3.22.0


NAME="gnome-color-manager"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-color-manager/3.22/gnome-color-manager-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-color-manager/3.22/gnome-color-manager-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-color-manager/gnome-color-manager-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-color-manager/3.22/gnome-color-manager-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-packagekit &&
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
