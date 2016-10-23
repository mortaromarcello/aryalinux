#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak GNOME Tweak Tool is a simplebr3ak program used to tweak advanced GNOME settings.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:gtk3
#REQ:gsettings-desktop-schemas
#REQ:python-modules#pygobject3


#VER:gnome-tweak-tool:3.22.0


NAME="gnome-tweak-tool"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.22/gnome-tweak-tool-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.22/gnome-tweak-tool-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.22/gnome-tweak-tool-3.22.0.tar.xz
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
