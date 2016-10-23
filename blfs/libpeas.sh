#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libpeas is a GObject based pluginsbr3ak engine, and is targeted at giving every application the chance tobr3ak assume its own extensibility.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:gobject-introspection
#REQ:gtk3
#REC:python-modules#pygobject3
#OPT:gdb
#OPT:gtk-doc
#OPT:valgrind


#VER:lua:5.1.5
#VER:libpeas:1.20.0


NAME="libpeas"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpeas/libpeas-1.20.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpeas/libpeas-1.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libpeas/1.20/libpeas-1.20.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libpeas/1.20/libpeas-1.20.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpeas/libpeas-1.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpeas/libpeas-1.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpeas/libpeas-1.20.0.tar.xz
wget -nc http://www.lua.org/ftp/lua-5.1.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.1.5.tar.gz


URL=http://ftp.gnome.org/pub/gnome/sources/libpeas/1.20/libpeas-1.20.0.tar.xz
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
