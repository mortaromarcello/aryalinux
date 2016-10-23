#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The cups-pk-helper packagebr3ak contains a PolicyKit helper usedbr3ak to configure Cups withbr3ak fine-grained privileges.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cups
#REQ:polkit


#VER:cups-pk-helper:0.2.6


NAME="cups-pk-helper"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-pk-helper-0.2.6.tar.xz || wget -nc http://www.freedesktop.org/software/cups-pk-helper/releases/cups-pk-helper-0.2.6.tar.xz


URL=http://www.freedesktop.org/software/cups-pk-helper/releases/cups-pk-helper-0.2.6.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
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
