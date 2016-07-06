#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libffi:3.2.1

#OPT:dejagnu


cd $SOURCE_DIR

URL=ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in &&
sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in        &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libffi=>`date`" | sudo tee -a $INSTALLED_LIST

