#!/bin/bash

set -e
set +h

./umountal.sh

. ./build-properties

LABEL=$1
TOOLCHAIN_BACKUP=$2
echo "Backing up for $LABEL."
sleep 5

LFS=/mnt/lfs
mount $ROOT_PART $LFS

if [ ! -z "$HOME_PART" ]
then

mount $HOME_PART $LFS/home

fi

pushd /

if [ -z $(ls $LFS/sources/aryalinux-$OS_VERSION-$LABEL*.tar.gz) ]
then
	GZIP=-9 tar --exclude="/mnt/lfs/sources" --exclude="/mnt/lfs/tools" --exclude="/mnt/lfs/root/.ccache" --exclude="/mnt/lfs/home/aryalinux/.ccache" --exclude="/mnt/lfs/var/cache/alps/binaries" --exclude="/mnt/lfs/var/cache/alps/sources" -czvf $LFS/sources/aryalinux-$OS_VERSION-$LABEL-`uname -m`-`date -I`.tar.gz $LFS
	if [ "$TOOLCHAIN_BACKUP" == "y" ] || [ "$TOOLCHAIN_BACKUP" == "Y" ] && [ -z $(ls $LFS/sources/toolchain*.tar.xz) ] ; then
		XZ_OPT=-9 tar -cJvf $LFS/sources/toolchain-$OS_VERSION-`uname -m`-`date -I`.tar.xz $LFS/tools
	fi
fi

#mkdir -pv ~/packages
#if [ -d /mnt/lfs/var/cache/alps/binaries/ ] && [ $(ls -A /mnt/lfs/var/cache/alps/binaries/) ] ; then
#	cp -v /mnt/lfs/var/cache/alps/binaries/* ~/packages
#fi

popd
