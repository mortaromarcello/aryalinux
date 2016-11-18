#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GNOME Bluetooth packagebr3ak contains tools for managing and manipulating Bluetooth devicesbr3ak using the GNOME Desktop.br3ak"
SECTION="gnome"
VERSION=3.20.0
NAME="gnome-bluetooth"

#REQ:gtk3
#REQ:itstool
#REQ:libcanberra
#REC:gobject-introspection
#OPT:gtk-doc
#OPT:bluez
#OPT:systemd


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.20/gnome-bluetooth-3.20.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.20/gnome-bluetooth-3.20.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.20/gnome-bluetooth-3.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.20.0.tar.xz

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
