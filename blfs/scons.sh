#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:scons:2.4.0

cd $SOURCE_DIR

URL=http://prdownloads.sourceforge.net/scons/scons-2.4.0.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

python setup.py build &&
sudo python setup.py install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "scons=>`date`" | sudo tee -a $INSTALLED_LIST



