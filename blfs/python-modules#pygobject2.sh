#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:general

#REQ:glib2
#REQ:python-modules#py2cairo
#OPT:gobject-introspection
#OPT:libxslt


#VER:pygobject:2.28.6


NAME="python-modules#pygobject2"

wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.6.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.6.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/pygobject/pygobject-2.28.6-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/pygobject-2.28.6-fixes-1.patch


URL=http://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.6.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../pygobject-2.28.6-fixes-1.patch   &&
sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr --disable-introspection &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
