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

clear

echo "LFS=/mnt/lfs" >> build-properties

. ./build-properties

export LFS=/mnt/lfs

if [ ! -z "${ROOT_PART}" ]
then

if [ -b "${ROOT_PART}" ]
then
	mkfs -F -v -t ext4 ${ROOT_PART}
else
	print "${ROOT_PART} is not a valid partition. Aborting..."
	exit 1
fi
mkdir -pv $LFS
mount -v -t ext4 $ROOT_PART $LFS

else
	echo "You must specify a root partition for build to proceed."
	exit 1
fi

if [ -b "${SWAP_PART}" ]
then
	if [ -z `swapon -s` | grep "${SWAP_PART} " ]
	then
		if [ "${FORMAT_SWAP}" == "y" ] || [ "${FORMAT_SWAP}" == "Y" ]
		then
			mkswap ${SWAP_PART}
		fi
		swapon ${SWAP_PART}
	else
		echo 'Swap partition exists and is active. Not formatting'
	fi
else
	print "${SWAP_PART} is not a valid partition. Aborting..."
	exit 1
fi

if [ ! -z "${HOME_PART}" ]
	if [ -b "${HOME_PART}" ]
	then
		if [ "${FORMAT_HOME}" == "y" ] || [ "${FORMAT_HOME}" == "Y" ]
		then
			mkfs.ext4 -F -v "${HOME_PART}"
		fi
		mkdir -pv $LFS/home
		mount ${HOME_PART} $LFS/home
	else
		print "${HOME_PART} is not a valid home partition. Aborting..."
		exit 1
	fi
fi

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
