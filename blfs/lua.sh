#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Lua is a powerful light-weightbr3ak programming language designed for extending applications. It isbr3ak also frequently used as a general-purpose, stand-alone language.br3ak Lua is implemented as a smallbr3ak library of C functions, written in ANSI C, and compiles unmodifiedbr3ak in all known platforms. The implementation goals are simplicity,br3ak efficiency, portability, and low embedding cost. The result is abr3ak fast language engine with small footprint, making it ideal inbr3ak embedded systems too.br3ak
#SECTION:general



#VER:lua:5.3.3
#VER:lua-tests:5.3.3


NAME="lua"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.3.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lua/lua-5.3.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.3.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.3.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.3.3.tar.gz || wget -nc http://www.lua.org/ftp/lua-5.3.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/lua/lua-5.3.3-shared_library-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/lua-5.3.3-shared_library-1.patch
wget -nc http://www.lua.org/tests/lua-5.3.3-tests.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lua/lua-5.3.3-tests.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.3.3-tests.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.3.3-tests.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lua/lua-5.3.3-tests.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lua/lua-5.3.3-tests.tar.gz


URL=http://www.lua.org/ftp/lua-5.3.3.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > lua.pc << "EOF"
V=5.3
R=5.3.3

prefix=/usr
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/share/man/man1
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
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


patch -Np1 -i ../lua-5.3.3-shared_library-1.patch &&
sed -i '/#define LUA_ROOT/s:/usr/local/:/usr/:' src/luaconf.h &&

make MYCFLAGS="-DLUA_COMPAT_5_2 -DLUA_COMPAT_5_1" linux


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make INSTALL_TOP=/usr TO_LIB="liblua.so liblua.so.5.3 liblua.so.5.3.3" \
     INSTALL_DATA="cp -d" INSTALL_MAN=/usr/share/man/man1 install &&

mkdir -pv /usr/share/doc/lua-5.3.3 &&
cp -v doc/*.{html,css,gif,png} /usr/share/doc/lua-5.3.3 &&

install -v -m644 -D lua.pc /usr/lib/pkgconfig/lua.pc
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
