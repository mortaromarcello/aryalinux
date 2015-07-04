#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gcc-4.8.3.tar.bz2

if ! grep 036-gcc $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../gcc-4.8.3-branch_update-1.patch

patch -Np1 -i ../gcc-4.8.3-pure64_specs-1.patch

echo -en '\n#undef STANDARD_STARTFILE_PREFIX_1\n#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"\n' >> gcc/config/linux.h
echo -en '\n#undef STANDARD_STARTFILE_PREFIX_2\n#define STANDARD_STARTFILE_PREFIX_2 ""\n' >> gcc/config/linux.h

touch /tools/include/limits.h

mkdir -v ../gcc-build
cd ../gcc-build

AR=ar LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
    ../gcc-4.8.3/configure --prefix=/cross-tools \
    --build=${CLFS_HOST} --host=${CLFS_HOST} --target=${CLFS_TARGET} \
    --with-sysroot=${CLFS} --with-local-prefix=/tools \
    --with-native-system-header-dir=/tools/include --disable-nls \
    --disable-shared --with-mpfr=/cross-tools --with-gmp=/cross-tools \
    --with-isl=/cross-tools --with-cloog=/cross-tools --with-mpc=/cross-tools \
    --without-headers --with-newlib --disable-decimal-float --disable-libgomp \
    --disable-libmudflap --disable-libssp --disable-libatomic --disable-libitm \
    --disable-libsanitizer --disable-libquadmath --disable-threads \
    --disable-multilib --disable-target-zlib --with-system-zlib \
    --enable-languages=c --enable-checking=release

make all-gcc all-target-libgcc

make install-gcc install-target-libgcc

cd $SOURCE_DIR
rm -rf $DIR
echo 036-gcc >> $LOG

fi
