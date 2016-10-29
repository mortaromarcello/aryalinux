#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Okular is a document viewer for KDE. It can view documents of manybr3ak types including PDF, PostScript, TIFF, Microsoft CHM, DjVu, DVI,br3ak XPS and ePub.br3ak"
SECTION="kde"
VERSION=412
NAME="okular5"

#REQ:kframeworks5
#REC:libkexiv2
#REC:libtiff
#REC:poppler
#OPT:qca


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/okular/okular-15.12.1+df0c412.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/okular/okular-15.12.1+df0c412.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
