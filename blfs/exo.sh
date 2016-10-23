#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Exo is a support library used inbr3ak the Xfce desktop. It also has somebr3ak helper applications that are used throughout Xfce.br3ak
#SECTION:xfce

whoami > /tmp/currentuser

#REQ:libxfce4ui
#REQ:libxfce4util
#REQ:perl-modules#perl-uri
#OPT:gtk-doc


#VER:exo:0.10.7


NAME="exo"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/exo/exo-0.10.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/exo/exo-0.10.7.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/exo/0.10/exo-0.10.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/exo/exo-0.10.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/exo/exo-0.10.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/exo/exo-0.10.7.tar.bz2


URL=http://archive.xfce.org/src/xfce/exo/0.10/exo-0.10.7.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
