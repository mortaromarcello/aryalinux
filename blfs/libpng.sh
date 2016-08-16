#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libpng:1.6.23
#VER:libpng-apng.patch:1.6.23



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/libpng/libpng-1.6.23.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.23.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.23.tar.xz || wget -nc http://downloads.sourceforge.net/libpng/libpng-1.6.23.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.23.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.23.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.23.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.23-apng.patch.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.23-apng.patch.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.23-apng.patch.gz || wget -nc http://downloads.sourceforge.net/project/apng/libpng/libpng16/libpng-1.6.23-apng.patch.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.23-apng.patch.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.23-apng.patch.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

gzip -cd ../libpng-1.6.23-apng.patch.gz | patch -p0 &&
sed -i '2138,2140 s/^/#/' Makefile.in


./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -v /usr/share/doc/libpng-1.6.23 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.23

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libpng=>`date`" | sudo tee -a $INSTALLED_LIST

