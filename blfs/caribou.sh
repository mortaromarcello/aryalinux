#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Caribou is an input assistivebr3ak technology intended for switch and pointer users.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:clutter
#REQ:gtk3
#REQ:libgee
#REQ:libxklavier
#REQ:python-modules#pygobject3
#REC:vala
#OPT:gtk2
#OPT:python-modules#dbus-python
#OPT:dconf
#OPT:python-modules#pyatspi2


#VER:caribou:0.4.21


NAME="caribou"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/caribou/caribou-0.4.21.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --disable-gtk2-module \
            --disable-static &&
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