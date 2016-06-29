#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://aryalinux.org/packages/2015/aryalinux-wallpaper.tar.xz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sudo tar -xf wallpapers.tar.gz -C /

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "aryalinux-wallpapers=>`date`" | sudo tee -a $INSTALLED_LIST


