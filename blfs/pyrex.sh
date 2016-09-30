#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:python2

cd $SOURCE_DIR

URL="https://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/Pyrex-0.9.9.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

python setup.py build
sudo python setup.py install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "pyrex=>`date`" | sudo tee -a $INSTALLED_LIST
