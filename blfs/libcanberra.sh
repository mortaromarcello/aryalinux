#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libcanberra:0.30

#REQ:libvorbis
#REC:alsa-lib
#REC:gstreamer10
#REC:gtk3
#OPT:gtk2
#OPT:gtk-doc
#OPT:pulseaudio


cd $SOURCE_DIR

URL=http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-oss &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/libcanberra-0.30 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable canberra-system-bootup

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libcanberra=>`date`" | sudo tee -a $INSTALLED_LIST

