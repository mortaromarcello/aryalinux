#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak v4l-utils provides a series ofbr3ak utilities for media devices, allowing to handle the proprietarybr3ak formats available at most webcams (libv4l), and providing tools tobr3ak test V4L devices.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:glu
#REQ:libjpeg
#REQ:mesa
#OPT:alsa-lib
#OPT:qt5
#OPT:doxygen


#VER:v4l-utils:1.10.1


NAME="v4l-utils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/v4l-utils/v4l-utils-1.10.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/v4l-utils/v4l-utils-1.10.1.tar.bz2 || wget -nc https://www.linuxtv.org/downloads/v4l-utils/v4l-utils-1.10.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/v4l-utils/v4l-utils-1.10.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/v4l-utils/v4l-utils-1.10.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/v4l-utils/v4l-utils-1.10.1.tar.bz2


URL=https://www.linuxtv.org/downloads/v4l-utils/v4l-utils-1.10.1.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST