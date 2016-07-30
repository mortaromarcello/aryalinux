#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:dvd+rw-tools:7.1



cd $SOURCE_DIR

URL=http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz || wget -nc http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dvd+rw-tools/dvd+rw-tools-7.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/stdlib/a #include <limits.h>' transport.hxx &&
sed -i 's#mkisofs"#xorrisofs"#' growisofs.c &&
sed -i 's#mkisofs#xorrisofs#;s#MKISOFS#XORRISOFS#' growisofs.1 &&
make all rpl8 btcflash



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install &&
install -v -m644 -D index.html \
    /usr/share/doc/dvd+rw-tools-7.1/index.html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "dvd-rw-tools=>`date`" | sudo tee -a $INSTALLED_LIST

