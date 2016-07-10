#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:t1lib:5.1.2

cd $SOURCE_DIR

URL=http://fossies.org/linux/misc/t1lib-5.1.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
wget -c $URL || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/t1lib/t1lib-5.1.2.tar.gz/a5629b56b93134377718009df1435f3c/t1lib-5.1.2.tar.gz || wget -nc http://fossies.org/linux/misc/old/t1lib-5.1.2.tar.gz || wget -nc http://ibiblio.org/pub/linux/libs/graphics/t1lib-5.1.2.tar.gz || wget -nc http://www6.frugalware.org/mirrors/linux/frugalware/frugalware-1.9/source/xlib/t1lib/t1lib-5.1.2.tar.gz
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`" without_doc

sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "t1lib=>`date`" | sudo tee -a $INSTALLED_LIST
