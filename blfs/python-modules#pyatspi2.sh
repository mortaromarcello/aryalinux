#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pyatspi:2.20.2

#REQ:python-modules#pygobject3
#REC:at-spi2-core


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/pyatspi/2.20/pyatspi-2.20.2.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/pyatspi/2.20/pyatspi-2.20.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pyatspi/2.20/pyatspi-2.20.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

mkdir python2 &&
pushd python2 &&
../configure --prefix=/usr --with-python=/usr/bin/python &&
make &&
popd

mkdir python3 &&
pushd python3 &&
../configure --prefix=/usr --with-python=/usr/bin/python3 &&
make &&
popd


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C python2 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C python3 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "python-modules#pyatspi2=>`date`" | sudo tee -a $INSTALLED_LIST

