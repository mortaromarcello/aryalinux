#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:midori__all_:0.5.11

#REQ:cmake
#REQ:gcr
#REQ:libnotify
#REQ:webkitgtk
#REQ:vala
#REC:librsvg
#OPT:gtk-doc
#OPT:webkitgtk2


cd $SOURCE_DIR

URL=http://www.midori-browser.org/downloads/midori_0.5.11_all_.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2 || wget -nc http://www.midori-browser.org/downloads/midori_0.5.11_all_.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DUSE_ZEITGEIST=OFF         \
      -DHALF_BRO_INCOM_WEBKIT2=ON \
      -DUSE_GTK3=1                \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/midori-0.5.11 \
      ..  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "midori=>`date`" | sudo tee -a $INSTALLED_LIST

