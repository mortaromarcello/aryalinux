#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:mongodb-src-r:3.0.7

#REQ:scons

cd $SOURCE_DIR

URL=https://fastdl.mongodb.org/src/mongodb-src-r3.0.7.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sudo scons all --disable-warnings-as-errors --prefix=/usr install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "mongodb=>`date`" | sudo tee -a $INSTALLED_LIST


