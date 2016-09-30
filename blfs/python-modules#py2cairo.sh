#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:py2cairo:1.10.0

#REQ:python2
#REQ:cairo


cd $SOURCE_DIR

URL=http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2

wget -nc http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./waf configure --prefix=/usr &&
./waf build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./waf install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "python-modules#py2cairo=>`date`" | sudo tee -a $INSTALLED_LIST

