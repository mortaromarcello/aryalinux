#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.libsdl.org/release/SDL-1.2.15.tar.gz


TARBALL=SDL-1.2.15.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/_XData32/s:register long:register _Xconst long:' src/video/x11/SDL_x11sym.h &&

./configure --prefix=/usr --disable-static --disable-sdl-dlopen &&
make

cat > 1434987998837.sh << "ENDOFFILE"
make install &&

install -v -dm755 /usr/share/doc/SDL-1.2.15/html &&
install -v -m644  docs/html/*.html \
                  /usr/share/doc/SDL-1.2.15/html
ENDOFFILE
chmod a+x 1434987998837.sh
sudo ./1434987998837.sh
sudo rm -rf 1434987998837.sh

cd test &&
./configure &&
make


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "sdl=>`date`" | sudo tee -a $INSTALLED_LIST