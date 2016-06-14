#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xfburn:0.5.4

#REQ:exo
#REQ:libxfce4util
#REQ:libisoburn
#REQ:gst10-plugins-base


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/apps/xfburn/0.5/xfburn-0.5.4.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2 || wget -nc http://archive.xfce.org/src/apps/xfburn/0.5/xfburn-0.5.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xfburn=>`date`" | sudo tee -a $INSTALLED_LIST

