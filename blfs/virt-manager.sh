#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:virt-manager:1.4.0

#REQ:python2
#REQ:gtk3
#REQ:libvirt
#REQ:libvirt-python
#REQ:libvirt-glib
#REQ:python-ipaddr
#REQ:python-requests
#REQ:python-modules#pygobject3
#REQ:libosinfo

cd $SOURCE_DIR

URL="https://virt-manager.org/download/sources/virt-manager/virt-manager-1.4.0.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

python setup.py build
sudo python setup.py install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "virt-manager=>`date`" | sudo tee -a $INSTALLED_LIST
