#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:conky:svn

#REQ:cmake
#REQ:git
#REQ:lua
#REQ:toluapp
#REQ:imlib2

cd $SOURCE_DIR

rm -rf conky
git clone https://github.com/brndnmtthws/conky.git
cd conky/
cmake -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_IMLIB2=ON -DBUILD_LUA_CAIRO=ON -DBUILD_LUA_IMLIB2=ON -DBUILD_LUA_RSVG=ON -DBUILD_XDBE=ON -DBUILD_XSHAPE=ON .
make
sudo make install

cd $SOURCE_DIR
rm -rf conky

echo "conky=>`date`" | sudo tee -a $INSTALLED_LIST


