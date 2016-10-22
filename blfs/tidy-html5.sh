#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:tidy-html5:5.2.0

#REQ:cmake
#REC:libxslt
#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/htacg/tidy-html5/archive/5.2.0.tar.gz

wget -nc https://github.com/htacg/tidy-html5/archive/5.2.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

wget -c https://github.com/htacg/tidy-html5/archive/5.2.0.tar.gz \
     -O tidy-html5-5.2.0.tar.gz


cd build/cmake &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DBUILD_TAB2SPACE=ON        \
      ../..    &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 tab2space /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "tidy-html5=>`date`" | sudo tee -a $INSTALLED_LIST

