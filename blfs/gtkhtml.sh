#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The GtkHTML package contains abr3ak lightweight HTML rendering/printing/editing engine.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:enchant
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:iso-codes
#REC:libsoup


#VER:gtkhtml:4.10.0


NAME="gtkhtml"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkhtml/4.10/gtkhtml-4.10.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.10.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gtkhtml/4.10/gtkhtml-4.10.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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
