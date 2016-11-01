#!/bin/bash

set -e
set +h

./umountal.sh

. ./build-properties

LFS=/mnt/lfs
mount $ROOT_PART $LFS

if [ ! -z "$HOME_PART" ]
then

mount $HOME_PART $LFS/home

fi

pushd $LFS

XZ_OPT=-9 tar --exclude=sources* --exclude=tools* --exclude=root/.ccache* --exclude=home/aryalinux/.ccache* --exclude=var/cache/alps/sources/* -cJvf ~/aryalinux-$OS_VERSION-`uname -m`-`date -I`.tar.xz * && XZ_OPT=-9 tar -cJvf ~/toolchain-$OS_VERSION-`uname -m`-`date -I`.tar.xz tools

popd

./umountal.sh
