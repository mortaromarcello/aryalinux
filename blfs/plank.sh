#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:plank:0.11.1

#REQ:libgee
#REQ:libbamf3

cd $SOURCE_DIR

URL=https://launchpad.net/plank/1.0/0.11.1/+download/plank-0.11.1.tar.xz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "plank=>`date`" | sudo tee -a $INSTALLED_LIST



