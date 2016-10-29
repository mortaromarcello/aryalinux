#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="A cross platform UI library for which bindings are available in C++, Python etc."
NAME="wxwidgets"
VERSION="3.0.2"

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
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
