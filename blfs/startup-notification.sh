#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The startup-notification packagebr3ak contains <code class="filename">startup-notificationbr3ak libraries. These are useful for building a consistent manner tobr3ak notify the user through the cursor that the application is loading.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:x7lib
#REQ:xcb-util


#VER:startup-notification:0.12


NAME="startup-notification"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc http://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz


URL=http://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
