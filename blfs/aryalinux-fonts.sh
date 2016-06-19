#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://aryalinux.org/packages/2015/aryalinux-font.tar.xz
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=0B12bXgUaD30LWGg5NUNlS1EyNHM' -O aryalinux-font.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sudo tar xf fonts.tar.gz -C /

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "aryalinux-fonts=>`date`" | sudo tee -a $INSTALLED_LIST


