#!/bin/bash

set -e
set +h

export SOURCE_DIR="/sources"
export LOG_PATH="/sources/build.log"

export STEP_NAME="09-python"
export TARBALL="Python-2.7.10.tar.xz"
export DIRECTORY="Python-2.7.10"

touch $LOG_PATH
cd $SOURCE_DIR

if ! grep "$STEP_NAME" $LOG_PATH
then

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --enable-unicode=ucs4 &&
make "-j`nproc`"
make install &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEP_NAME" >> $LOG_PATH

fi


