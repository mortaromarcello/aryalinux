#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:setuptools:18.5

cd $SOURCE_DIR

URL=https://pypi.python.org/packages/source/s/setuptools/setuptools-18.5.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

python setup.py build &&
sudo python setup.py install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "setuptools=>`date`" | sudo tee -a $INSTALLED_LIST



