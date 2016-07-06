#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:nasm-xdoc:2.12
#VER:nasm:2.12



cd $SOURCE_DIR

URL=http://www.nasm.us/pub/nasm/releasebuilds/2.12/nasm-2.12.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nasm/nasm-2.12-xdoc.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12-xdoc.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12-xdoc.tar.xz || wget -nc http://www.nasm.us/pub/nasm/releasebuilds/2.12/nasm-2.12-xdoc.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12-xdoc.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12-xdoc.tar.xz
wget -nc http://www.nasm.us/pub/nasm/releasebuilds/2.12/nasm-2.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nasm/nasm-2.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../nasm-2.12-xdoc.tar.xz --strip-components=1


./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -m755 -d         /usr/share/doc/nasm-2.12/html  &&
cp -v doc/html/*.html    /usr/share/doc/nasm-2.12/html  &&
cp -v doc/*.{txt,ps,pdf} /usr/share/doc/nasm-2.12       &&
cp -v doc/info/*         /usr/share/info                   &&
install-info /usr/share/info/nasm.info /usr/share/info/dir

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "nasm=>`date`" | sudo tee -a $INSTALLED_LIST

