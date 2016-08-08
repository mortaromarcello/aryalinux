#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:exiv2:0.25

#REC:curl
#OPT:doxygen
#OPT:graphviz
#OPT:python3
#OPT:libxslt


cd $SOURCE_DIR

URL=http://www.exiv2.org/exiv2-0.25.tar.gz

wget -nc http://www.exiv2.org/exiv2-0.25.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/exiv2/exiv2-0.25.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/exiv2/exiv2-0.25.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/exiv2/exiv2-0.25.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/exiv2/exiv2-0.25.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/exiv2/exiv2-0.25.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --enable-video    \
            --enable-webready \
            --without-ssh     \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libexiv2.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "exiv2=>`date`" | sudo tee -a $INSTALLED_LIST

