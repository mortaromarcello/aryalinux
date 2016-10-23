#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Wayland is a project to define abr3ak protocol for a compositor to talk to its clients as well as abr3ak library implementation of the protocol.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libffi
#OPT:doxygen
#OPT:graphviz
#OPT:xmlto
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt


#VER:wayland:1.12.0


NAME="wayland"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://wayland.freedesktop.org/releases/wayland-1.12.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wayland/wayland-1.12.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wayland/wayland-1.12.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wayland/wayland-1.12.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wayland/wayland-1.12.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wayland/wayland-1.12.0.tar.xz


URL=http://wayland.freedesktop.org/releases/wayland-1.12.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --disable-documentation &&
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
