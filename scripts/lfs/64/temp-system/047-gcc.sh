#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gcc-4.8.3.tar.bz2

if ! grep 048-gcc $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../gcc-4.8.3-branch_update-1.patch

patch -Np1 -i ../gcc-4.8.3-pure64_specs-1.patch

echo -en '\n#undef STANDARD_STARTFILE_PREFIX_1\n#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"\n' >> gcc/config/linux.h
echo -en '\n#undef STANDARD_STARTFILE_PREFIX_2\n#define STANDARD_STARTFILE_PREFIX_2 ""\n' >> gcc/config/linux.h

cp -v gcc/Makefile.in{,.orig}
sed 's@\./fixinc\.sh@-c true@' gcc/Makefile.in.orig > gcc/Makefile.in

mkdir -v ../gcc-build
cd ../gcc-build

../gcc-4.8.3/configure --prefix=/tools \
    --build=${CLFS_HOST} --host=${CLFS_TARGET} --target=${CLFS_TARGET} \
    --with-local-prefix=/tools --disable-multilib --disable-nls \
    --enable-languages=c,c++ --disable-libstdcxx-pch --with-system-zlib \
    --with-native-system-header-dir=/tools/include --disable-libssp \
    --enable-checking=release --enable-libstdcxx-time

cp -v Makefile{,.orig}
sed "/^HOST_\(GMP\|ISL\|CLOOG\)\(LIBS\|INC\)/s:/tools:/cross-tools:g" \
    Makefile.orig > Makefile

make AS_FOR_TARGET="${AS}" \
    LD_FOR_TARGET="${LD}"

make install

cp -v ../gcc-4.8.3/include/libiberty.h /tools/include

cd $SOURCE_DIR
rm -rf $DIR
echo 048-gcc >> $LOG

fi
