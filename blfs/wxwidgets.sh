#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:wxwidgets:3.0.2

cd $SOURCE_DIR

URL=https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.2/wxWidgets-3.0.2.tar.bz2
wget -nc $URL
wget -nc aryalinux.org/releases/2016.08/wxwidgets-3.0.2-scintilla.patch
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./autogen.sh --prefix=/usr
./configure --prefix=/usr &&
patch -Np1 -i ../wxwidgets-3.0.2-scintilla.patch &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "wxwidgets=>`date`" | sudo tee -a $INSTALLED_LIST


