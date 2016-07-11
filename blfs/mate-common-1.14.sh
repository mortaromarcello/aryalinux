#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL1="http://pub.mate-desktop.org/releases/1.14/mate-common-1.14.1.tar.xz"
URL2="http://pub.mate-desktop.org/releases/1.14/mate-common-1.14.0.tar.xz"
{
	wget -nc $URL1 && URL=$URL1
} || {
	wget -nc $URL2 && URL=$URL2
}

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static --with-gtk=3.0 &&
make "-j4"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "mate-common-1.14=>`date`" | sudo tee -a $INSTALLED_LIST
