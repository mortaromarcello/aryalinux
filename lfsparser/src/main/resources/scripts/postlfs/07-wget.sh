#!/bin/bash

set -e
set +h

export SOURCE_DIR="/sources"
export LOG_PATH="/sources/build.log"

export STEP_NAME="07-wget"
export TARBALL="wget-1.16.3.tar.xz"
export DIRECTORY="wget-1.16.3"

touch $LOG_PATH
cd $SOURCE_DIR

if ! grep "$STEP_NAME" $LOG_PATH
then

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make "-j`nproc`"
make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEP_NAME" >> $LOG_PATH

fi

