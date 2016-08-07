#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:startup-notification:0.12

#REQ:x7lib
#REQ:xcb-util


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc http://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D doc/startup-notification.txt \
    /usr/share/doc/startup-notification-0.12/startup-notification.txt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "startup-notification=>`date`" | sudo tee -a $INSTALLED_LIST

