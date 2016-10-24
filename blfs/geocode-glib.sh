#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Geocode GLib is a conveniencebr3ak library for the Yahoo! Place Finder APIs. The Place Finder webbr3ak service allows to do geocoding (finding longitude and latitude frombr3ak an address), and reverse geocoding (finding an address frombr3ak coordinates).br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:json-glib
#REQ:libsoup
#REC:gobject-introspection
#OPT:gtk-doc


#VER:geocode-glib:3.20.1


NAME="geocode-glib"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/geocode-glib/geocode-glib-3.20.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/geocode-glib/geocode-glib-3.20.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.20/geocode-glib-3.20.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/geocode-glib/geocode-glib-3.20.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.20/geocode-glib-3.20.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/geocode-glib/geocode-glib-3.20.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/geocode-glib/geocode-glib-3.20.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.20/geocode-glib-3.20.1.tar.xz
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
