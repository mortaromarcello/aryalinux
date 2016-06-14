#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:jasper:1.900.1

#REQ:unzip
#REC:libjpeg
#OPT:freeglut


cd $SOURCE_DIR

URL=http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip

wget -nc http://www.linuxfromscratch.org/patches/downloads/jasper/jasper-1.900.1-security_fixes-2.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/jasper-1.900.1-security_fixes-2.patch
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jasper/jasper-1.900.1.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jasper/jasper-1.900.1.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jasper/jasper-1.900.1.zip || wget -nc http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jasper/jasper-1.900.1.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jasper/jasper-1.900.1.zip

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=''
unzip_dirname $TARBALL DIRECTORY

unzip_file $TARBALL
cd $DIRECTORY

patch -Np1 -i ../jasper-1.900.1-security_fixes-2.patch &&
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static \
            --mandir=/usr/share/man &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/jasper-1.900.1 &&
install -v -m644 doc/*.pdf /usr/share/doc/jasper-1.900.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "jasper=>`date`" | sudo tee -a $INSTALLED_LIST

