#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=coreutils-8.22.tar.xz

if ! grep 053-coreutils $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


cat > config.cache << EOF
fu_cv_sys_stat_statfs2_bsize=yes
gl_cv_func_working_mkstemp=yes
EOF

patch -Np1 -i ../coreutils-8.22-noman-1.patch

./configure --prefix=/tools \
    --build=${CLFS_HOST} --host=${CLFS_TARGET} \
    --enable-install-program=hostname --cache-file=config.cache

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 053-coreutils >> $LOG

fi
