#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:phonon-backend-gstreamer:4.9.0

#REQ:gstreamer10
#REQ:libxml2
#REQ:phonon
#REC:gst10-plugins-base
#REC:gst10-plugins-good
#REC:gst10-plugins-bad
#REC:gst10-plugins-ugly


cd $SOURCE_DIR

URL=http://download.kde.org/stable/phonon/phonon-backend-gstreamer/4.9.0/phonon-backend-gstreamer-4.9.0.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/phonon-backend-gstreamer/phonon-backend-gstreamer-4.9.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/phonon-backend-gstreamer/phonon-backend-gstreamer-4.9.0.tar.xz || wget -nc http://download.kde.org/stable/phonon/phonon-backend-gstreamer/4.9.0/phonon-backend-gstreamer-4.9.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon-backend-gstreamer/phonon-backend-gstreamer-4.9.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/phonon-backend-gstreamer/phonon-backend-gstreamer-4.9.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon-backend-gstreamer/phonon-backend-gstreamer-4.9.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_INSTALL_LIBDIR=lib     \
      -DCMAKE_BUILD_TYPE=Release     \
      -DPHONON_BUILD_PHONON4QT5=ON   \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "phonon-backend-gstreamer=>`date`" | sudo tee -a $INSTALLED_LIST

