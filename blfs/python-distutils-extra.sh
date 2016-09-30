#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:python-modules#setuptools

URL=https://launchpad.net/python-distutils-extra/trunk/2.39/+download/python-distutils-extra-2.39.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

python setup.py build &&
sudo python setup.py install

python3 setup.py build &&
sudo python3 setup.py install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "python-distutils-extra=>`date`" | sudo tee -a $INSTALLED_LIST
