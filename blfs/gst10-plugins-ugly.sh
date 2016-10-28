#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GStreamer Ugly Plug-ins is abr3ak set of plug-ins considered by the GStreamer developers to have good quality andbr3ak correct functionality, but distributing them might pose problems.br3ak The license on either the plug-ins or the supporting librariesbr3ak might not be how the GStreamerbr3ak developers would like. The code might be widely known to presentbr3ak patent problems.br3ak
#SECTION:multimedia

#REQ:gst10-plugins-base
#REC:lame
#REC:libdvdread
#REC:x264
#OPT:liba52
#OPT:libmad
#OPT:libmpeg2
#OPT:libcdio
#OPT:mpg123
#OPT:valgrind


#VER:gst-plugins-ugly:1.8.3


NAME="gst10-plugins-ugly"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.8.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.8.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.8.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.8.3.tar.xz || wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.8.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gst-plugins-ugly/gst-plugins-ugly-1.8.3.tar.xz


URL=http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.8.3.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --with-package-name="GStreamer Ugly Plugins 1.8.3 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
