#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libnl:3.2.27
#VER:libnl-doc:3.2.27

#OPT:check


cd $SOURCE_DIR

URL=https://github.com/thom311/libnl/releases/download/libnl3_2_27/libnl-3.2.27.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnl/libnl-doc-3.2.27.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-doc-3.2.27.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-doc-3.2.27.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-doc-3.2.27.tar.gz || wget -nc https://github.com/thom311/libnl/releases/download/libnl3_2_27/libnl-doc-3.2.27.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-doc-3.2.27.tar.gz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-3.2.27.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-3.2.27.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnl/libnl-3.2.27.tar.gz || wget -nc https://github.com/thom311/libnl/releases/download/libnl3_2_27/libnl-3.2.27.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnl/libnl-3.2.27.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnl/libnl-3.2.27.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -vp /usr/share/doc/libnl-3.2.27 &&
tar -xf ../libnl-doc-3.2.27.tar.gz --strip-components=1 --no-same-owner \
    -C  /usr/share/doc/libnl-3.2.27

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libnl=>`date`" | sudo tee -a $INSTALLED_LIST

