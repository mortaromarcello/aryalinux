#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GObject Introspection is usedbr3ak to describe the program APIs and collect them in a uniform, machinebr3ak readable format.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#REQ:python2
#OPT:cairo
#OPT:gtk-doc
#OPT:python-modules#Mako


#VER:gobject-introspection:1.50.0


NAME="gobject-introspection"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gobject-introspection/gobject-introspection-1.50.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gobject-introspection/gobject-introspection-1.50.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.50/gobject-introspection-1.50.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.50/gobject-introspection-1.50.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gobject-introspection/gobject-introspection-1.50.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gobject-introspection/gobject-introspection-1.50.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gobject-introspection/gobject-introspection-1.50.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.50/gobject-introspection-1.50.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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
