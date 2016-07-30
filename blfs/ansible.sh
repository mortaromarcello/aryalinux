#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:ansible:1.9.1

cd $SOURCE_DIR

URL=https://pypi.python.org/packages/source/a/ansible/ansible-1.9.4.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

python setup.py build &&
sudo python setup.py install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "ansible=>`date`" | sudo tee -a $INSTALLED_LIST



