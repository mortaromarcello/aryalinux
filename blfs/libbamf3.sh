#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:libbamf3:0.5.1
#REQ:libwnck
#REQ:libgtop

cd $SOURCE_DIR

URL=https://launchpad.net/bamf/0.5/0.5.1/+download/bamf-0.5.1.tar.gz
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

echo "libbamf3=>`date`" | sudo tee -a $INSTALLED_LIST



