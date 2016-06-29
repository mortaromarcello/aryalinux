#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:MarkupSafe:0.23

#REQ:python-modules#setuptools


cd $SOURCE_DIR

URL=https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz

wget -nc https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

python setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


python3 setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python3 setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "python-modules#MarkupSafe=>`date`" | sudo tee -a $INSTALLED_LIST

