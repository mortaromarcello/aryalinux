#!/bin/bash

export LFS=/mnt/lfs
mkdir -pv $LFS

./umountal.sh

read -p "Enter the root partition name : " ROOT_PART
read -p "Enter the swap partition name : " SWAP_PART
read -p "Enter the home partition name : " HOME_PART
read -p "Mount kernel filesystems as well? (y/n) : " RESP

mount -v -t ext4 $ROOT_PART $LFS

if [ "x$SWAP_PART" != "x" ]
then
	swapon $SWAP_PART
fi

if [ "x$HOME_PART" != "x" ]
then
	mount $HOME_PART $LFS/home
fi

if [ "x$RESP" == "xy" ] || [ "X$RESP" == "XY" ]
then
	mount -v --bind /dev $LFS/dev

	mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
	mount -vt proc proc $LFS/proc
	mount -vt sysfs sysfs $LFS/sys
	mount -vt tmpfs tmpfs $LFS/run

	if [ -h $LFS/dev/shm ]; then
	  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
	fi
fi

cat > $LFS/bin/stripdebug <<EOF
/tools/bin/find /{,usr/}{bin,lib,sbin} -type f \
    -exec /tools/bin/strip --strip-debug '{}' ';'
EOF
chmod a+x $LFS/bin/stripdebug

chroot $LFS /tools/bin/env -i            \
    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin   \
    /tools/bin/bash --login
