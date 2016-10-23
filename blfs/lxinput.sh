#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The LXInput package contains abr3ak small program used to configure keyboard and mouse for LXDE.br3ak
#SECTION:lxde

whoami > /tmp/currentuser

#REQ:gtk2


#VER:lxinput:0.3.5


NAME="lxinput"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.sourceforge.net/lxde/lxinput-0.3.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxinput/lxinput-0.3.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxinput/lxinput-0.3.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxinput/lxinput-0.3.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxinput/lxinput-0.3.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxinput/lxinput-0.3.5.tar.xz


URL=http://downloads.sourceforge.net/lxde/lxinput-0.3.5.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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
