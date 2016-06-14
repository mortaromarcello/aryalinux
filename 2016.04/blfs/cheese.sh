#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:cheese:3.16.1

#REQ:clutter-gst
#REQ:clutter-gtk
#REQ:gnome-desktop
#REQ:gnome-video-effects
#REQ:gst10-plugins-bad
#REQ:gst10-plugins-good
#REQ:v4l-utils
#REQ:itstool
#REQ:libcanberra
#REQ:libgudev
#REQ:clutter-gst2
#REC:appstream-glib
#REC:gobject-introspection
#REC:vala
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/cheese/3.16/cheese-3.16.1.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cheese/cheese-3.16.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cheese/cheese-3.16.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cheese/cheese-3.16.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cheese/cheese-3.16.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/cheese/3.16/cheese-3.16.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cheese/3.16/cheese-3.16.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cheese/cheese-3.16.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
echo "cheese=>`date`" | sudo tee -a $INSTALLED_LIST

