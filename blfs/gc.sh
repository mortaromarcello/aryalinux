#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gc:7.4.4

#REQ:libatomic_ops


cd $SOURCE_DIR

URL=http://www.hboehm.info/gc/gc_source/gc-7.4.4.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gc/gc-7.4.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gc/gc-7.4.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gc/gc-7.4.4.tar.gz || wget -nc http://www.hboehm.info/gc/gc_source/gc-7.4.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gc/gc-7.4.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gc/gc-7.4.4.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's#pkgdata#doc#' doc/doc.am &&
autoreconf -fi  &&
./configure --prefix=/usr      \
            --enable-cplusplus \
            --disable-static   \
            --docdir=/usr/share/doc/gc-7.4.4 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 doc/gc.man /usr/share/man/man3/gc_malloc.3 &&
ln -sfv gc_malloc.3 /usr/share/man/man3/gc.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gc=>`date`" | sudo tee -a $INSTALLED_LIST

