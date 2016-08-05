#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libidn:1.33

#OPT:pth
#OPT:emacs
#OPT:gtk-doc
#OPT:openjdk
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc http://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
find doc -name "Makefile*" -delete            &&
rm -rf -v doc/{gdoc,idn.1,stamp-vti,man,texi} &&
mkdir -v       /usr/share/doc/libidn-1.33     &&
cp -r -v doc/* /usr/share/doc/libidn-1.33

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libidn=>`date`" | sudo tee -a $INSTALLED_LIST

