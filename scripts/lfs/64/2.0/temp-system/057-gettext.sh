#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gettext-0.19.1.tar.gz

if ! grep 058-gettext $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


cd gettext-tools

echo "gl_cv_func_wcwidth_works=yes" > config.cache

./configure --prefix=/tools \
    --build=${CLFS_HOST} --host=${CLFS_TARGET} \
    --disable-shared --cache-file=config.cache

make -C gnulib-lib
make -C src msgfmt msgmerge xgettext

cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin

cd $SOURCE_DIR
rm -rf $DIR
echo 058-gettext >> $LOG

fi
