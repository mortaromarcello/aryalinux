#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:faad2:2.7



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/faac/faad2-2.7.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/downloads/faad2/faad2-2.7-mp4ff-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/faad2-2.7-mp4ff-1.patch
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/faad2/faad2-2.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/faad2/faad2-2.7.tar.bz2 || wget -nc http://downloads.sourceforge.net/faac/faad2-2.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/faad2/faad2-2.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/faad2/faad2-2.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/faad2/faad2-2.7.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../faad2-2.7-mp4ff-1.patch &&
sed -i "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" configure.in &&
sed -i "s:man_MANS:man1_MANS:g" frontend/Makefile.am         &&
autoreconf -fi &&
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
echo "faad2=>`date`" | sudo tee -a $INSTALLED_LIST

