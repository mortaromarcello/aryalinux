#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://aryalinux.org/packages/2015/aryalinux-wallpaper.tar.xz
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=0B12bXgUaD30LbDZnd3ZoM0J1dGM' -O aryalinux-wallpaper.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sudo tar -xf wallpapers.tar.gz -C /

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "aryalinux-wallpapers=>`date`" | sudo tee -a $INSTALLED_LIST


