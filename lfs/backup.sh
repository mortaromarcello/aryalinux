#!/bin/bash

set -e
set +h

./umountal.sh

. ./build-properties

LABEL=$1
echo "Backing up for $LABEL."
sleep 5

LFS=/mnt/lfs
mount $ROOT_PART $LFS

if [ ! -z "$HOME_PART" ]
then

mount $HOME_PART $LFS/home

fi

pushd $LFS

if [ -z "`ls | grep -E 'aryalinux-$OS_VERSION-$LABEL'`" ]
then
	XZ_OPT=-9 tar --exclude=sources* --exclude=tools* --exclude=root/.ccache* --exclude=home/aryalinux/.ccache* --exclude=var/cache/alps/binaries --exclude=var/cache/alps/sources/* -cJvf ~/aryalinux-$OS_VERSION-$LABEL-`uname -m`-`date -I`.tar.xz * && XZ_OPT=-9 tar -cJvf ~/toolchain-$OS_VERSION-`uname -m`-`date -I`.tar.xz tools
fi

mkdir ~/packages
cp -v var/cache/alps/binaries/* ~/packages

popd

./umountal.sh
