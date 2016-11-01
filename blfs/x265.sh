#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak x265 package provides a librarybr3ak for encoding video streams into the H.265/HEVC format.br3ak"
SECTION="multimedia"
VERSION=265_2.1
NAME="x265"

#REQ:cmake
#REC:yasm


cd $SOURCE_DIR

URL=https://bitbucket.org/multicoreware/x265/downloads/x265_2.1.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/x265/x265_2.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/x265/x265_2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/x265/x265_2.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/x265/x265_2.1.tar.gz || wget -nc https://bitbucket.org/multicoreware/x265/downloads/x265_2.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/x265/x265_2.1.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/x265_2.1-enable_static-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/x265/x265_2.1-enable_static-1.patch

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

patch -Np1 -i ../x265_2.1-enable_static-1.patch &&
mkdir bld &&
cd    bld &&
cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=/usr \
      -DENABLE_STATIC=OFF         \
      ../source                   &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
