#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lua:5.1.5
#VER:libpeas:1.18.0

#REQ:gobject-introspection
#REQ:gtk3
#REC:python-modules#pygobject3
#OPT:gdb
#OPT:gtk-doc
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libpeas/1.18/libpeas-1.18.0.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc http://www.lua.org/ftp/lua-5.1.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lua/lua-5.1.5.tar.gz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpeas/libpeas-1.18.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpeas/libpeas-1.18.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpeas/libpeas-1.18.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libpeas/1.18/libpeas-1.18.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpeas/libpeas-1.18.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libpeas/1.18/libpeas-1.18.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpeas/libpeas-1.18.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
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
echo "libpeas=>`date`" | sudo tee -a $INSTALLED_LIST

