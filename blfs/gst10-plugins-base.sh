#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gst-plugins-base:1.6.3

#REQ:gstreamer10
#REC:alsa-lib
#REC:gobject-introspection
#REC:iso-codes
#REC:libogg
#REC:libtheora
#REC:libvorbis
#REC:x7lib
#OPT:cdparanoia
#OPT:gtk3
#OPT:gtk-doc
#OPT:qt4
#OPT:valgrind


cd $SOURCE_DIR

URL=http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.6.3.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins/gst-plugins-base-1.6.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins/gst-plugins-base-1.6.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins/gst-plugins-base-1.6.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins/gst-plugins-base-1.6.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins/gst-plugins-base-1.6.3.tar.xz || wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.6.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --with-package-name="GStreamer Base Plugins 1.6.3 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gst10-plugins-base=>`date`" | sudo tee -a $INSTALLED_LIST

