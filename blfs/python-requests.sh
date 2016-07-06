#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:python-requests:2.10.0

#REQ:python2

cd $SOURCE_DIR

URL="https://pypi.python.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

python setup.py build
sudo python setup.py install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "python-requests=>`date`" | sudo tee -a $INSTALLED_LIST
