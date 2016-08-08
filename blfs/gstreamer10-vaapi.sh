#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gstreamer-vaapi:1.8.2

#REQ:gstreamer10
#REQ:gst10-plugins-base
#REQ:gst10-plugins-bad


cd $SOURCE_DIR

URL=http://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-1.8.2.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.2.tar.xz || wget -nc http://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-1.8.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gstreamer/gstreamer-vaapi-1.8.2.tar.xz

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
echo "gstreamer10-vaapi=>`date`" | sudo tee -a $INSTALLED_LIST

