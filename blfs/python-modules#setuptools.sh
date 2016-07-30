#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:setuptools:17.1.1

#REQ:python2
#REQ:python3


cd $SOURCE_DIR

URL=https://pypi.python.org/packages/source/s/setuptools/setuptools-17.1.1.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/setuptools/setuptools-17.1.1.tar.gz || wget -nc https://pypi.python.org/packages/source/s/setuptools/setuptools-17.1.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/setuptools/setuptools-17.1.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/setuptools/setuptools-17.1.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/setuptools/setuptools-17.1.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/setuptools/setuptools-17.1.1.tar.gz

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
python3 setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "python-modules#setuptools=>`date`" | sudo tee -a $INSTALLED_LIST

