#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libgudev package containsbr3ak GObject bindings for libudev.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#OPT:gobject-introspection
#OPT:gtk-doc


#VER:libgudev:230


NAME="libgudev"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgudev/libgudev-230.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgudev/libgudev-230.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgudev/libgudev-230.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libgudev/230/libgudev-230.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgudev/230/libgudev-230.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgudev/libgudev-230.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgudev/libgudev-230.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libgudev/230/libgudev-230.tar.xz
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
