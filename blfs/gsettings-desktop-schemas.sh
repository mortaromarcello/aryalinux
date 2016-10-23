#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GSettings Desktop Schemasbr3ak package contains a collection of GSettings schemas for settingsbr3ak shared by various components of a GNOME Desktop.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:glib2
#REC:gobject-introspection


#VER:gsettings-desktop-schemas:3.22.0


NAME="gsettings-desktop-schemas"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.22/gsettings-desktop-schemas-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.22/gsettings-desktop-schemas-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.22/gsettings-desktop-schemas-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -r 's:"(/system):"/org/gnome\1:g' schemas/*.in &&
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
