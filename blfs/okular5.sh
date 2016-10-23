#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Okular is a document viewer for KDE. It can view documents of manybr3ak types including PDF, PostScript, TIFF, Microsoft CHM, DjVu, DVI,br3ak XPS and ePub.br3ak
#SECTION:kde

whoami > /tmp/currentuser

#REQ:kframeworks5
#REC:libkexiv2
#REC:libtiff
#REC:poppler
#OPT:qca


#VER:okular-15.12.1+df0c:412


NAME="okular5"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/okular/okular-15.12.1+df0c412.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/okular/okular-15.12.1+df0c412.tar.xz


URL=http://anduin.linuxfromscratch.org/BLFS/okular/okular-15.12.1+df0c412.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
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
