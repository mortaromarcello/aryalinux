#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Clutter Gst is an integrationbr3ak library for using GStreamer withbr3ak Clutter. Its purpose is tobr3ak implement the ClutterMedia interface using GStreamer.br3ak"
SECTION="x"
VERSION=3.0.20
NAME="clutter-gst"

#REQ:clutter
#REQ:gst10-plugins-base
#REQ:libgudev
#REC:gobject-introspection
#REC:gst10-plugins-bad
#OPT:gtk-doc


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-gst-3.0.20.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.20.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-gst-3.0.20.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-gst-3.0.20.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.20.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-gst-3.0.20.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clutter/clutter-gst-3.0.20.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.20.tar.xz
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
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
