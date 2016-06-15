#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:v:2.1



cd $SOURCE_DIR

URL=https://github.com/cjlin1/liblinear/archive/v2.1.tar.gz

wget -nc https://github.com/cjlin1/liblinear/archive/v2.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

wget -c https://github.com/cjlin1/liblinear/archive/v2.1.tar.gz \
     -O liblinear-2.1.tar.gz


make lib



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vm644 linear.h /usr/include &&
install -vm755 liblinear.so.3 /usr/lib &&
ln -sfv liblinear.so.3 /usr/lib/liblinear.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "liblinear=>`date`" | sudo tee -a $INSTALLED_LIST

