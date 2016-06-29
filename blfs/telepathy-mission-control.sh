#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:telepathy-mission-control:5.16.3

#REQ:telepathy-glib
#REC:networkmanager
#OPT:gtk-doc
#OPT:upower


cd $SOURCE_DIR

URL=http://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.3.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.3.tar.gz || wget -nc http://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-mission-control/telepathy-mission-control-5.16.3.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static --disable-upower &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "telepathy-mission-control=>`date`" | sudo tee -a $INSTALLED_LIST

