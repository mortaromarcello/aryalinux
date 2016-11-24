set -e
set +h

. /sources/build-properties

LFS=/mnt/lfs

chown -R root:root $LFS/tools

mkdir -pv $LFS/{dev,proc,sys,run}
if [ ! -e $LFS/dev/console ]; then
	mknod -m 600 $LFS/dev/console c 5 1
fi
if [ ! -e $LFS/dev/null ]; then
	mknod -m 666 $LFS/dev/null c 1 3
fi
mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

# Building Final System

chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='\u:\w\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h /sources/stage4.sh
