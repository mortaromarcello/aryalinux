#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libpng package containsbr3ak libraries used by other programs for reading and writing PNG files.br3ak The PNG format was designed as a replacement for GIF and, to abr3ak lesser extent, TIFF, with many improvements and extensions and lackbr3ak of patent problems.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:libpng:1.6.24
#VER:libpng-apng.patch:1.6.24


NAME="libpng"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.24.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.24.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.24.tar.xz || wget -nc http://downloads.sourceforge.net/libpng/libpng-1.6.24.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.24.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.24.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.24-apng.patch.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.24-apng.patch.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.24-apng.patch.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.24-apng.patch.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.24-apng.patch.gz || wget -nc http://downloads.sourceforge.net/project/apng/libpng/libpng16/libpng-1.6.24-apng.patch.gz


URL=http://downloads.sourceforge.net/libpng/libpng-1.6.24.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

gzip -cd ../libpng-1.6.24-apng.patch.gz | patch -p0


./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -v /usr/share/doc/libpng-1.6.24 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.24

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST