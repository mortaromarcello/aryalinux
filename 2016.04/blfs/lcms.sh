#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lcms:1.19

#OPT:libtiff
#OPT:libjpeg
#OPT:python2
#OPT:swig


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/lcms-1.19-cve_2013_4276-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/lcms/lcms-1.19-cve_2013_4276-1.patch
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms/lcms-1.19.tar.gz || wget -nc http://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../lcms-1.19-cve_2013_4276-1.patch &&
./configure --prefix=/usr --disable-static       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/lcms-1.19 &&
install -v -m644    README.1ST doc/* \
                    /usr/share/doc/lcms-1.19

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "lcms=>`date`" | sudo tee -a $INSTALLED_LIST

