#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:Mako:1.0.4

#REQ:python-modules#Beaker
#REQ:python-modules#MarkupSafe


cd $SOURCE_DIR

URL=https://pypi.python.org/packages/source/M/Mako/Mako-1.0.4.tar.gz

wget -nc https://pypi.python.org/packages/source/M/Mako/Mako-1.0.4.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i "s:mako-render:&3:g" setup.py &&
python3 setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "python-modules#Mako=>`date`" | sudo tee -a $INSTALLED_LIST

