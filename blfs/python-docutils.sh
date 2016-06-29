#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:python-docutils_+dfsg.orig:0.12

cd $SOURCE_DIR

URL="http://archive.ubuntu.com/ubuntu/pool/main/p/python-docutils/python-docutils_0.12+dfsg.orig.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

python setup.py build
sudo python setup.py install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "python-docutils=>`date`" | sudo tee -a $INSTALLED_LIST
