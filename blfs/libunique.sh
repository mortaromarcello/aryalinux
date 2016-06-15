#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libunique:1.1.6

#REQ:gtk2
#OPT:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/downloads/libunique/libunique-1.1.6-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libunique-1.1.6-upstream_fixes-1.patch
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2 || wget -nc http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libunique/libunique-1.1.6.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../libunique-1.1.6-upstream_fixes-1.patch &&
autoreconf -fi &&
./configure --prefix=/usr  \
            --disable-dbus \
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
echo "libunique=>`date`" | sudo tee -a $INSTALLED_LIST

