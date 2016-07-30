#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:jack:1.9.10

cd $SOURCE_DIR

URL=https://dl.dropboxusercontent.com/u/28869550/jack-1.9.10.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./waf configure --prefix=/usr &&
./waf build
sudo ./waf install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "jack2=>`date`" | sudo tee -a $INSTALLED_LIST


