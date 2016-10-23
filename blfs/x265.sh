#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak x265 package provides a librarybr3ak for encoding video streams into the H.265/HEVC format.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:cmake
#REC:yasm


#VER:x:265_2.1


NAME="x265"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/x265/x265_2.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/x265/x265_2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/x265/x265_2.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/x265/x265_2.1.tar.gz || wget -nc https://bitbucket.org/multicoreware/x265/downloads/x265_2.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/x265/x265_2.1.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/x265_2.1-enable_static-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/x265/x265_2.1-enable_static-1.patch


URL=https://bitbucket.org/multicoreware/x265/downloads/x265_2.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

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




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
