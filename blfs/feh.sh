#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:feh:2.16.1

#REQ:libpng
#REQ:imlib2
#REQ:giflib
#REC:curl
#OPT:libexif
#OPT:libjpeg
#OPT:imagemagick
#OPT:perl-modules#perl-test-command


cd $SOURCE_DIR

URL=http://feh.finalrewind.org/feh-2.16.1.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/downloads/feh/feh-2.16.1-disable_some_tests-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/feh-2.16.1-disable_some_tests-1.patch
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/feh/feh-2.16.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/feh/feh-2.16.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/feh/feh-2.16.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/feh/feh-2.16.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/feh/feh-2.16.1.tar.bz2 || wget -nc http://feh.finalrewind.org/feh-2.16.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../feh-2.16.1-disable_some_tests-1.patch


sed -i "s:doc/feh:&-2.16.1:" config.mk &&
make PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "feh=>`date`" | sudo tee -a $INSTALLED_LIST

