#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The LLVM package contains abr3ak collection of modular and reusable compiler and toolchainbr3ak technologies. The Low Level Virtual Machine (LLVM) Core librariesbr3ak provide a modern source and target-independent optimizer, alongbr3ak with code generation support for many popular CPUs (as well as somebr3ak less common ones!). These libraries are built around a wellbr3ak specified code representation known as the LLVM intermediatebr3ak representation ("LLVM IR").br3ak
#SECTION:general

#REC:cmake
#REC:libffi
#REC:python2
#OPT:doxygen
#OPT:graphviz
#OPT:libxml2
#OPT:texlive
#OPT:tl-installer
#OPT:valgrind
#OPT:zip


#VER:cfe-.src:3.9.0
#VER:compiler-rt-.src:3.9.0
#VER:llvm-.src:3.9.0


NAME="llvm"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-3.9.0.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/llvm/llvm-3.9.0.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-3.9.0.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-3.9.0.src.tar.xz || wget -nc http://llvm.org/releases/3.9.0/llvm-3.9.0.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-3.9.0.src.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/cfe-3.9.0.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/llvm/cfe-3.9.0.src.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/llvm/cfe-3.9.0.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/llvm/cfe-3.9.0.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/cfe-3.9.0.src.tar.xz || wget -nc http://llvm.org/releases/3.9.0/cfe-3.9.0.src.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.9.0.src.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.9.0.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/compiler-rt/compiler-rt-3.9.0.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.9.0.src.tar.xz || wget -nc http://llvm.org/releases/3.9.0/compiler-rt-3.9.0.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.9.0.src.tar.xz


URL=http://llvm.org/releases/3.9.0/llvm-3.9.0.src.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

tar -xf ../cfe-3.9.0.src.tar.xz -C tools &&
tar -xf ../compiler-rt-3.9.0.src.tar.xz -C projects &&

mv tools/cfe-3.9.0.src tools/clang &&
mv projects/compiler-rt-3.9.0.src projects/compiler-rt

mkdir -v build &&
cd       build &&

CC=gcc CXX=g++                              \
cmake -DCMAKE_INSTALL_PREFIX=/usr           \
      -DLLVM_ENABLE_FFI=ON                  \
      -DCMAKE_BUILD_TYPE=Release            \
      -DLLVM_BUILD_LLVM_DYLIB=ON            \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU" \
      -Wno-dev ..                           &&
make

cmake -DLLVM_ENABLE_SPHINX=ON         \
      -DSPHINX_WARNINGS_AS_ERRORS=OFF \
      -Wno-dev ..                     &&
make docs-llvm-html  docs-llvm-man

make docs-clang-html docs-clang-man


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 docs/man/* /usr/share/man/man1             &&
install -v -d -m755 /usr/share/doc/llvm-3.9.0/llvm-html     &&
cp -Rv docs/html/* /usr/share/doc/llvm-3.9.0/llvm-html
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 tools/clang/docs/man/* /usr/share/man/man1 &&
install -v -d -m755 /usr/share/doc/llvm-3.9.0/clang-html    &&
cp -Rv tools/clang/docs/html/* /usr/share/doc/llvm-3.9.0/clang-html
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
