#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnu-gs-fonts-other:6.0
#VER:ghostscript:9.18
#VER:ghostscript-fonts-std:8.11

#REC:freetype2
#REC:libjpeg
#REC:libpng
#REC:libtiff
#REC:lcms2
#OPT:cairo
#OPT:cups
#OPT:fontconfig
#OPT:gtk2
#OPT:libidn
#OPT:libpaper
#OPT:lcms
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://downloads.ghostscript.com/public/ghostscript-9.18.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc http://downloads.sourceforge.net/gs-fonts/gnu-gs-fonts-other-6.0.tar.gz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ghostscript/ghostscript-9.18.tar.bz2 || wget -nc http://downloads.ghostscript.com/public/ghostscript-9.18.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ghostscript/ghostscript-9.18.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ghostscript/ghostscript-9.18.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ghostscript/ghostscript-9.18.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ghostscript/ghostscript-9.18.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ghostscript-fonts-std/ghostscript-fonts-std-8.11.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ghostscript-fonts-std/ghostscript-fonts-std-8.11.tar.gz || wget -nc http://downloads.sourceforge.net/gs-fonts/ghostscript-fonts-std-8.11.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ghostscript-fonts-std/ghostscript-fonts-std-8.11.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ghostscript-fonts-std/ghostscript-fonts-std-8.11.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ghostscript-fonts-std/ghostscript-fonts-std-8.11.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/ZLIBDIR=src/ZLIBDIR=$includedir/' configure.ac configure &&
rm -rf freetype lcms2 jpeg libpng


rm -rf zlib &&
./configure --prefix=/usr           \
            --disable-compile-inits \
            --enable-dynamic        \
            --with-system-libtiff   &&
make "-j`nproc`"


make so



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make soinstall &&
install -v -m644 base/*.h /usr/include/ghostscript &&
ln -v -s ghostscript /usr/include/ps

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -sfvn ../ghostscript/9.18/doc /usr/share/doc/ghostscript-9.18

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gs=>`date`" | sudo tee -a $INSTALLED_LIST

