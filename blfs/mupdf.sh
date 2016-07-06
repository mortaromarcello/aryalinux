#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mupdf-source:1.8

#REQ:x7lib
#REQ:xorg-server
#REC:libjpeg
#REC:openjpeg2
#REC:curl
#OPT:openssl


cd $SOURCE_DIR

URL=http://www.mupdf.com/downloads/archive/mupdf-1.8-source.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/mupdf-1.8-openjpeg21-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/mupdf/mupdf-1.8-openjpeg21-1.patch
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mupdf/mupdf-1.8-source.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mupdf/mupdf-1.8-source.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mupdf/mupdf-1.8-source.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mupdf/mupdf-1.8-source.tar.gz || wget -nc http://www.mupdf.com/downloads/archive/mupdf-1.8-source.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mupdf/mupdf-1.8-source.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

rm -rf thirdparty/curl     &&
rm -rf thirdparty/freetype &&
rm -rf thirdparty/jpeg     &&
rm -rf thirdparty/openjpeg &&
rm -rf thirdparty/zlib     &&
patch -Np1 -i ../mupdf-1.8-openjpeg21-1.patch &&
make build=release



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 build/release/mupdf-x11-curl /usr/bin/mupdf &&
install -v -m 644 docs/man/mupdf.1 /usr/share/man/man1/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mupdf=>`date`" | sudo tee -a $INSTALLED_LIST

