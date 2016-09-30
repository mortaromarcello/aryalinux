#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xfce4-notifyd:0.2.4

#REQ:libnotify
#REQ:libxfce4ui


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/apps/xfce4-notifyd/0.2/xfce4-notifyd-0.2.4.tar.bz2

wget -nc http://archive.xfce.org/src/apps/xfce4-notifyd/0.2/xfce4-notifyd-0.2.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-notifyd-0.2.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-notifyd-0.2.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-notifyd-0.2.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-notifyd-0.2.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-notifyd-0.2.4.tar.bz2

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


notify-send -i info Information "Hi ${USER}, This is a Test"


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xfce4-notifyd=>`date`" | sudo tee -a $INSTALLED_LIST

