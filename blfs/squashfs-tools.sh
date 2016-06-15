#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:squashfs-tools:4.3

cd $SOURCE_DIR

URL="http://pkgs.fedoraproject.org/repo/pkgs/squashfs-tools/squashfs4.3.tar.gz/370d0470f3c823bf408a3b7a1f145746/squashfs4.3.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

cd squashfs-tools
sed 's@#XZ_SUPPORT@XZ_SUPPORT@g' -i Makefile
sed 's@COMP_DEFAULT = gzip@COMP_DEFAULT = xz@g' -i Makefile
make
sudo make INSTALL_DIR=/bin install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "squashfs-tools=>`date`" | sudo tee -a $INSTALLED_LIST
