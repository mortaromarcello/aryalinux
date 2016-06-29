#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:clutter-gst:3.0.18

#REQ:clutter
#REQ:gst10-plugins-base
#REC:gobject-introspection
#REC:gst10-plugins-bad
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.18.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clutter-gst/clutter-gst-3.0.18.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clutter-gst/clutter-gst-3.0.18.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter-gst/clutter-gst-3.0.18.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clutter-gst/clutter-gst-3.0.18.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter-gst/clutter-gst-3.0.18.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.18.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.18.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
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
echo "clutter-gst=>`date`" | sudo tee -a $INSTALLED_LIST

