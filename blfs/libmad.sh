#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libmad-b:0.15.1



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/mad/libmad-0.15.1b.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmad/libmad-0.15.1b.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmad/libmad-0.15.1b.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmad/libmad-0.15.1b.tar.gz || wget -nc http://downloads.sourceforge.net/mad/libmad-0.15.1b.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmad/libmad-0.15.1b.tar.gz || wget -nc ftp://ftp.mars.org/pub/mpeg/libmad-0.15.1b.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmad/libmad-0.15.1b.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/libmad/libmad-0.15.1b-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libmad-0.15.1b-fixes-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../libmad-0.15.1b-fixes-1.patch                &&
sed "s@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@g" -i configure.ac &&
touch NEWS AUTHORS ChangeLog                                 &&
autoreconf -fi                                               &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /usr/lib/pkgconfig/mad.pc << "EOF"
prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include
Name: mad
Description: MPEG audio decoder
Requires:
Version: 0.15.1b
Libs: -L${libdir} -lmad
Cflags: -I${includedir}
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libmad=>`date`" | sudo tee -a $INSTALLED_LIST

