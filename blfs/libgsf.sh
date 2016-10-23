#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libgsf package contains abr3ak library used for providing an extensible input/output abstractionbr3ak layer for structured file formats.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#REQ:libxml2
#REC:gdk-pixbuf
#OPT:gobject-introspection
#OPT:gtk-doc


#VER:libgsf:1.14.40


NAME="libgsf"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.40.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgsf/libgsf-1.14.40.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.40.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.40.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
