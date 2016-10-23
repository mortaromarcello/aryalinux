#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The ISO Codes package contains abr3ak list of country, language and currency names and it is used as abr3ak central database for accessing this data.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:python3


#VER:iso-codes:3.70


NAME="iso-codes"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/iso-codes/iso-codes-3.70.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/iso-codes/iso-codes-3.70.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/iso-codes/iso-codes-3.70.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/iso-codes/iso-codes-3.70.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/iso-codes/iso-codes-3.70.tar.xz || wget -nc https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.70.tar.xz


URL=https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.70.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
