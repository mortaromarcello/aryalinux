#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://download.redis.io/releases/redis-3.0.5.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make "-j`nproc`"
sudo make PREFIX=/usr install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "redis=>`date`" | sudo tee -a $INSTALLED_LIST


