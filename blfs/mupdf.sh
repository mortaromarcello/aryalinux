#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak MuPDF is a lightweight PDF and XPSbr3ak viewer.br3ak"
SECTION="pst"
VERSION=1.9
NAME="mupdf"

#REQ:x7lib
#REQ:xorg-server
#REC:harfbuzz
#REC:libjpeg
#REC:openjpeg2
#REC:curl
#OPT:openssl


cd $SOURCE_DIR

URL=http://www.mupdf.com/downloads/archive/mupdf-1.9-source.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mupdf/mupdf-1.9-source.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mupdf/mupdf-1.9-source.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mupdf/mupdf-1.9-source.tar.gz || wget -nc http://www.mupdf.com/downloads/archive/mupdf-1.9-source.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mupdf/mupdf-1.9-source.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mupdf/mupdf-1.9-source.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/mupdf/mupdf-1.9-upstream_fix-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mupdf-1.9-upstream_fix-1.patch
wget -nc http://www.linuxfromscratch.org/patches/downloads/mupdf/mupdf-1.9-openjpeg21-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mupdf-1.9-openjpeg21-1.patch

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

rm -rf thirdparty/curl     &&
rm -rf thirdparty/freetype &&
rm -rf thirdparty/harfbuzz &&
rm -rf thirdparty/jpeg     &&
rm -rf thirdparty/openjpeg &&
rm -rf thirdparty/zlib     &&
patch -Np1 -i ../mupdf-1.9-upstream_fix-1.patch &&
patch -Np1 -i ../mupdf-1.9-openjpeg21-1.patch &&
make build=release



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 build/release/mupdf-x11-curl /usr/bin/mupdf &&
install -v -m 644 docs/man/mupdf.1 /usr/share/man/man1/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
