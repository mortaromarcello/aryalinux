#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:v:2.1.2

#REQ:cmake
#OPT:lcms2
#OPT:libpng
#OPT:libtiff
#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/uclouvain/openjpeg/archive/v2.1.2.tar.gz

wget -nc https://github.com/uclouvain/openjpeg/archive/v2.1.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

wget -c https://github.com/uclouvain/openjpeg/archive/v2.1.2.tar.gz \
     -O openjpeg-2.1.2.tar.gz


mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
pushd ../doc &&
for man in man/man?/* ; do
    install -v -D -m 644 $man /usr/share/$man
done         &&
popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "openjpeg2=>`date`" | sudo tee -a $INSTALLED_LIST

