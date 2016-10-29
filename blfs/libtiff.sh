#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The LibTIFF package contains thebr3ak TIFF libraries and associated utilities. The libraries are used bybr3ak many programs for reading and writing TIFF files and the utilitiesbr3ak are used for general work with TIFF files.br3ak"
SECTION="general"
VERSION=4.0.6
NAME="libtiff"

#OPT:freeglut
#OPT:libjpeg


cd $SOURCE_DIR

URL=http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz || wget -nc http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" config/ltmain.sh &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
