#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The gstreamer-vaapi packagebr3ak contains a GStreamer plugin forbr3ak hardware accelerated video decode/encode for the prevailing codingbr3ak standards today (MPEG-2, MPEG-4 ASP/H.263, MPEG-4 AVC/H.264, andbr3ak VC-1/VMW3).br3ak
#SECTION:multimedia

#REQ:gstreamer10
#REQ:gst10-plugins-base
#REQ:gst10-plugins-bad
#REQ:x7driver


#VER:gstreamer-vaapi:1.8.3


NAME="gstreamer10-vaapi"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.3.tar.xz || wget -nc http://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-1.8.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.3.tar.xz


URL=http://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-1.8.3.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
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
