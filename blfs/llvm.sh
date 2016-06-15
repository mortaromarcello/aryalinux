#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:compiler-rt-.src:3.7.1
#VER:llvm-.src:3.7.1
#VER:cfe-.src:3.7.1

#REC:libffi
#REC:python2
#OPT:cmake
#OPT:doxygen
#OPT:graphviz
#OPT:libxml2
#OPT:texlive
#OPT:tl-installer
#OPT:valgrind
#OPT:zip


cd $SOURCE_DIR

URL=http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-3.7.1.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-3.7.1.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/llvm/llvm-3.7.1.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-3.7.1.src.tar.xz || wget -nc http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-3.7.1.src.tar.xz
wget -nc http://llvm.org/releases/3.7.1/cfe-3.7.1.src.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/llvm/cfe-3.7.1.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/llvm/cfe-3.7.1.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/llvm/cfe-3.7.1.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/cfe-3.7.1.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/cfe-3.7.1.src.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.7.1.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.7.1.src.tar.xz || wget -nc http://llvm.org/releases/3.7.1/compiler-rt-3.7.1.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/compiler-rt/compiler-rt-3.7.1.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.7.1.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/compiler-rt/compiler-rt-3.7.1.src.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../cfe-3.7.1.src.tar.xz -C tools &&
tar -xf ../compiler-rt-3.7.1.src.tar.xz -C projects &&
mv tools/cfe-3.7.1.src tools/clang &&
mv projects/compiler-rt-3.7.1.src projects/compiler-rt


sed -r "/ifeq.*CompilerTargetArch/s#i386#i686#g" \
    -i projects/compiler-rt/make/platform/clang_linux.mk


sed -e "s:/docs/llvm:/share/doc/llvm-3.7.1:" \
    -i Makefile.config.in &&
mkdir -v build &&
cd       build &&
CC=gcc CXX=g++                          \
../configure --prefix=/usr              \
             --datarootdir=/usr/share   \
             --sysconfdir=/etc          \
             --enable-libffi            \
             --enable-optimized         \
             --enable-shared            \
             --enable-targets=host,r600 \
             --disable-assertions       \
             --docdir=/usr/share/doc/llvm-3.7.1 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
for file in /usr/lib/lib{clang,LLVM,LTO}*.a
do
  test -f $file && chmod -v 644 $file
done
unset file

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/lib/clang-analyzer &&
for prog in scan-build scan-view
do
  cp -rfv ../tools/clang/tools/$prog /usr/lib/clang-analyzer/ &&
  ln -sfv ../lib/clang-analyzer/$prog/$prog /usr/bin/
done
unset prog &&
ln -sfv /usr/bin/clang \
        /usr/lib/clang-analyzer/scan-build/ &&
mv -v   /usr/lib/clang-analyzer/scan-build/scan-build.1 \
        /usr/share/man/man1/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "llvm=>`date`" | sudo tee -a $INSTALLED_LIST

