#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libdrm:2.4.70

#REC:x7lib
#OPT:cairo
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:valgrind


cd $SOURCE_DIR

URL=http://dri.freedesktop.org/libdrm/libdrm-2.4.70.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdrm/libdrm-2.4.70.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdrm/libdrm-2.4.70.tar.bz2 || wget -nc http://dri.freedesktop.org/libdrm/libdrm-2.4.70.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdrm/libdrm-2.4.70.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdrm/libdrm-2.4.70.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdrm/libdrm-2.4.70.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/pthread-stubs/d" configure.ac  &&
autoreconf -fiv                         &&
./configure --prefix=/usr --enable-udev &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libdrm=>`date`" | sudo tee -a $INSTALLED_LIST

