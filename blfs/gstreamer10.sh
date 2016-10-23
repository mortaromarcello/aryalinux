#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak GStreamer is a streaming mediabr3ak framework that enables applications to share a common set ofbr3ak plugins for things like video encoding and decoding, audio encodingbr3ak and decoding, audio and video filters, audio visualisation, webbr3ak streaming and anything else that streams in real-time or otherwise.br3ak This package only provides base functionality and libraries. Youbr3ak may need at least <a class="xref" href="gst10-plugins-base.html" br3ak title="gst-plugins-base-1.8.3">gst-plugins-base-1.8.3</a> and onebr3ak of Good, Bad, Ugly or Libav plugins.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:glib2
#REC:gobject-introspection
#OPT:gtk3
#OPT:gsl
#OPT:gtk-doc
#OPT:valgrind


#VER:gstreamer:1.8.3


NAME="gstreamer10"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-1.8.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-1.8.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gstreamer/gstreamer-1.8.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-1.8.3.tar.xz || wget -nc http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.8.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-1.8.3.tar.xz


URL=http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.8.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --with-package-name="GStreamer 1.8.3 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
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
