#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ibus:1.5.11

#REQ:dconf
#REQ:iso-codes
#REC:gobject-introspection
#REC:gtk2
#REC:libnotify
#REC:vala
#OPT:python-modules#dbus-python
#OPT:python-modules#pygobject3
#OPT:gtk-doc
#OPT:python3
#OPT:python-modules#pyxdg
#OPT:libxkbcommon
#OPT:wayland


cd $SOURCE_DIR

URL=https://github.com/ibus/ibus/releases/download/1.5.11/ibus-1.5.11.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ibus/ibus-1.5.11.tar.gz || wget -nc https://github.com/ibus/ibus/releases/download/1.5.11/ibus-1.5.11.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ibus/ibus-1.5.11.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ibus/ibus-1.5.11.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ibus/ibus-1.5.11.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ibus/ibus-1.5.11.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
echo "ibus=>`date`" | sudo tee -a $INSTALLED_LIST

