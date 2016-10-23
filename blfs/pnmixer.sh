#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Pnmixer package provides abr3ak lightweight volume control with a tray icon.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:alsa-utils
#REQ:gtk2


#VER:pnmixer:0.5.1


NAME="pnmixer"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://github.com/downloads/nicklan/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pnmixer/pnmixer-0.5.1.tar.gz


URL=https://github.com/downloads/nicklan/pnmixer/pnmixer-0.5.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./autogen.sh --prefix=/usr &&
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
