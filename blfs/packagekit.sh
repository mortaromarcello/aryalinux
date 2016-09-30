#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#REQ:bash-completion

cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/PackageKit/releases/PackageKit-1.1.1.tar.xz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "packagekit=>`date`" | sudo tee -a $INSTALLED_LIST


