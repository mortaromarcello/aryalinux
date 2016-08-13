#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libtirpc:1.0.1

#OPT:mitkrb


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/project/libtirpc/libtirpc/1.0.1/libtirpc-1.0.1.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2 || wget -nc http://downloads.sourceforge.net/project/libtirpc/libtirpc/1.0.1/libtirpc-1.0.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libtirpc/libtirpc-1.0.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --disable-gssapi  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v /usr/lib/libtirpc.so.* /lib &&
ln -sfv ../../lib/libtirpc.so.3.0.0 /usr/lib/libtirpc.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libtirpc=>`date`" | sudo tee -a $INSTALLED_LIST

