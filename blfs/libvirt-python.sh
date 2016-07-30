#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libvirt-python:2.0.0

#REQ:libvirt

cd $SOURCE_DIR

URL="http://libvirt.org/sources/python/libvirt-python-2.0.0.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

python setup.py build
sudo python setup.py install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "libvirt-python=>`date`" | sudo tee -a $INSTALLED_LIST
