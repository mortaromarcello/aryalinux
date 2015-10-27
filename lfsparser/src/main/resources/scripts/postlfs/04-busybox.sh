#!/bin/bash

set -e
set +h

export SOURCE_DIR="/sources"
export LOG_PATH="/sources/build.log"

export STEP_NAME="04-busybox"
export TARBALL="busybox-1.20.2.tar.bz2"
export DIRECTORY="busybox-1.20.2"

touch $LOG_PATH
cd $SOURCE_DIR

if ! grep "$STEP_NAME" $LOG_PATH
then

tar -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../busybox-1.20.2-sys-resource.patch
make defconfig
sed 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' -i .config

sed 's/CONFIG_FEATURE_HAVE_RPC=y/# CONFIG_FEATURE_HAVE_RPC is not set/' \
        -i .config
sed 's/CONFIG_FEATURE_MOUNT_NFS=y/# CONFIG_FEATURE_MOUNT_NFS is not set/' \
        -i .config
sed 's/CONFIG_FEATURE_INETD_RPC=y/# CONFIG_FEATURE_INETD_RPC is not set/' \
        -i .config
make "-j`nproc`" || echo "..." >> $INSTALLED_LIST && make
cp -v busybox /bin

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEP_NAME" >> $LOG_PATH

fi
