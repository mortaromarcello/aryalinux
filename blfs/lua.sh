#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:lua:5.1

cd $SOURCE_DIR

URL="http://www.lua.org/ftp/lua-5.1.5.tar.gz"
wget -nc $URL
wget http://www.linuxfromscratch.org/patches/downloads/lua/lua-5.1.5-shared_library-2.patch
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../lua-5.1.5-shared_library-2.patch &&
sed -i '/#define LUA_ROOT/s:/usr/local/:/usr/:' src/luaconf.h &&
make linux

sudo make INSTALL_TOP=/usr TO_LIB="liblua.so liblua.so.5.1 liblua.so.5.1.5" \
     INSTALL_DATA="cp -d" INSTALL_MAN=/usr/share/man/man1 install &&
sudo mkdir -pv /usr/share/doc/lua-5.1.5 &&
sudo cp -v doc/*.{html,css,gif} /usr/share/doc/lua-5.1.5

sudo tee /usr/lib/pkgconfig/lua.pc << "EOF"
V=5.1
R=5.1.5

prefix=/usr
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/man/man1
INSTALL_LMOD=${prefix}/share/lua/${V}
INSTALL_CMOD=${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Lua
Description: An Extensible Extension Language
Version: ${R}
Requires: 
Libs: -L${libdir} -llua -lm
Cflags: -I${includedir}
EOF

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "lua=>`date`" | sudo tee -a $INSTALLED_LIST

