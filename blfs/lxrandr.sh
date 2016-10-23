#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The LXRandR package contains abr3ak monitor configuration tool for LXDE.br3ak
#SECTION:lxde

whoami > /tmp/currentuser

#REQ:gtk2
#REQ:x7app
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


#VER:lxrandr:0.3.1


NAME="lxrandr"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxrandr/lxrandr-0.3.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxrandr/lxrandr-0.3.1.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/lxrandr-0.3.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxrandr/lxrandr-0.3.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxrandr/lxrandr-0.3.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxrandr/lxrandr-0.3.1.tar.xz


URL=http://downloads.sourceforge.net/lxde/lxrandr-0.3.1.tar.xz
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
