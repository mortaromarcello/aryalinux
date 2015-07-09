#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.lua.org/ftp/lua-5.2.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/lua-5.2.3-shared_library-1.patch


TARBALL=lua-5.2.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../lua-5.2.3-shared_library-1.patch &&
sed -i '/#define LUA_ROOT/s:/usr/local/:/usr/:' src/luaconf.h &&
make linux

cat > 1434987998776.sh << "ENDOFFILE"
make INSTALL_TOP=/usr TO_LIB="liblua.so liblua.so.5.2 liblua.so.5.2.3" \
     INSTALL_DATA="cp -d" INSTALL_MAN=/usr/share/man/man1 install &&
mkdir -pv /usr/share/doc/lua-5.2.3 &&
cp -v doc/*.{html,css,gif,png} /usr/share/doc/lua-5.2.3
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
cat > /usr/lib/pkgconfig/lua.pc << "EOF"
V=5.2
R=5.2.3

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
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lua=>`date`" | sudo tee -a $INSTALLED_LIST