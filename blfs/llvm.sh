#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:compiler-rt-.src:3.8.0
#VER:llvm-.src:3.8.0
#VER:cfe-.src:3.8.0

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


cd $SOURCE_DIR

URL=http://llvm.org/releases/3.8.0/llvm-3.8.0.src.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/llvm/cfe-3.8.0.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/llvm/cfe-3.8.0.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/llvm/cfe-3.8.0.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/cfe-3.8.0.src.tar.xz || wget -nc http://llvm.org/releases/3.8.0/cfe-3.8.0.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/cfe-3.8.0.src.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/llvm/llvm-3.8.0.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-3.8.0.src.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-3.8.0.src.tar.xz || wget -nc http://llvm.org/releases/3.8.0/llvm-3.8.0.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-3.8.0.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-3.8.0.src.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.8.0.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.8.0.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/compiler-rt/compiler-rt-3.8.0.src.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.8.0.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.8.0.src.tar.xz || wget -nc http://llvm.org/releases/3.8.0/compiler-rt-3.8.0.src.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../cfe-3.8.0.src.tar.xz -C tools &&
tar -xf ../compiler-rt-3.8.0.src.tar.xz -C projects &&
mv tools/cfe-3.8.0.src tools/clang &&
mv projects/compiler-rt-3.8.0.src projects/compiler-rt


mkdir -v build &&
cd       build &&
CC=gcc CXX=g++                              \
cmake -DCMAKE_INSTALL_PREFIX=/usr           \
      -DLLVM_ENABLE_FFI=ON                  \
      -DCMAKE_BUILD_TYPE=Release            \
      -DBUILD_SHARED_LIBS=ON                \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU" \
      -Wno-dev ..                           &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "llvm=>`date`" | sudo tee -a $INSTALLED_LIST

