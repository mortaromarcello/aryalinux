#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:parted:3.2

#REC:lvm2
#OPT:pth
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz

wget -nc http://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/parted/parted-3.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/parted/parted-3.2.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/parted-3.2-devmapper-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/parted/parted-3.2-devmapper-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../parted-3.2-devmapper-1.patch


./configure --prefix=/usr --disable-static &&
make &&
make -C doc html                                       &&
makeinfo --html      -o doc/html       doc/parted.texi &&
makeinfo --plaintext -o doc/parted.txt doc/parted.texi


sed -i '/t0251-gpt-unicode.sh/d' tests/Makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755 /usr/share/doc/parted-3.2/html &&
install -v -m644  doc/html/* \
                  /usr/share/doc/parted-3.2/html &&
install -v -m644  doc/{FAT,API,parted.{txt,html}} \
                  /usr/share/doc/parted-3.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "parted=>`date`" | sudo tee -a $INSTALLED_LIST

