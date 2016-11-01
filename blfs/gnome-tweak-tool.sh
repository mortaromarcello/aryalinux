#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak GNOME Tweak Tool is a simplebr3ak program used to tweak advanced GNOME settings.br3ak"
SECTION="gnome"
VERSION=3.22.0
NAME="gnome-tweak-tool"

#REQ:gtk3
#REQ:gsettings-desktop-schemas
#REQ:python-modules#pygobject3


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.22/gnome-tweak-tool-3.22.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.22/gnome-tweak-tool-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.22/gnome-tweak-tool-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.22.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
