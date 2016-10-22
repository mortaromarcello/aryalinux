#!/bin/bash

set -e
set +h

clear

TIMEZONE=`tzselect`

rm -rf /tools
rm -rf /sources
rm -rf /mnt/lfs

cat >> build-properties << EOF
TIMEZONE=$TIMEZONE
EOF

echo "LFS=/mnt/lfs" >> build-properties

. ./build-properties

export LFS=/mnt/lfs

yes | mkfs -v -t ext4 ${ROOT_PART}

mkdir -pv $LFS
mount -v -t ext4 $ROOT_PART $LFS

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
ln -svf $LFS/sources /sources

cp -r ../sources/* $LFS/sources
touch $LFS/sources/currentstage

mkdir -v $LFS/tools
ln -sv $LFS/tools /

mkdir -pv $LFS/var/cache/alps/sources

if [ -d ../sources-apps ]
then
	cp -r ../sources-apps/* $LFS/var/cache/alps/sources/
	chmod -R a+rw $LFS/var/cache/alps/sources
fi

if grep lfs /etc/passwd
then
	userdel -r lfs
fi

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

cp -r * /home/lfs/
cp -r * /sources/
chown -R lfs:lfs /home/lfs/*
chown -R lfs:lfs /sources/*

chown -R lfs:lfs /home/lfs
