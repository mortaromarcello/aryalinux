#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GOffice package contains abr3ak library of GLib/GTK document centric objects and utilities.br3ak This is useful for performing common operations for documentbr3ak centric applications that are conceptually simple, but complex tobr3ak implement fully. Some of the operations provided by thebr3ak GOffice library include supportbr3ak for plugins, load/save routines for application documents andbr3ak undo/redo functions.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:gtk3
#REQ:libgsf
#REQ:librsvg
#REQ:libxslt
#REQ:general_which
#OPT:gobject-introspection
#OPT:gs
#OPT:gsettings-desktop-schemas
#OPT:gtk-doc


#VER:goffice:0.10.32


NAME="goffice010"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/goffice/0.10/goffice-0.10.32.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/goffice/0.10/goffice-0.10.32.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/goffice/0.10/goffice-0.10.32.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
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