#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:python-ipaddr:2.1.11

#REQ:python2
#REQ:python-modules#setuptools

cd $SOURCE_DIR

URL="https://pypi.python.org/packages/08/80/7539938aca4901864b7767a23eb6861fac18ef5219b60257fc938dae3568/ipaddr-2.1.11.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

python setup.py build
sudo python setup.py install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "python-ipaddr=>`date`" | sudo tee -a $INSTALLED_LIST
