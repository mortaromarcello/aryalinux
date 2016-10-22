#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pygobject:3.22.0

#REQ:gobject-introspection
#REQ:python-modules#py2cairo
#REQ:python-modules#pycairo


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/pygobject/3.22/pygobject-3.22.0.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/3.22/pygobject-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/3.22/pygobject-3.22.0.tar.xz

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
echo "python-modules#pygobject3=>`date`" | sudo tee -a $INSTALLED_LIST

