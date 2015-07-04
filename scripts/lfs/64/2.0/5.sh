#!/bin/bash

set -e
set +h

export CLFS=/mnt/clfs

mkdir -pv ${CLFS}/{dev,proc,run,sys}

mknod -m 600 ${CLFS}/dev/console c 5 1
mknod -m 666 ${CLFS}/dev/null c 1 3

mount -v -o bind /dev ${CLFS}/dev

mount -vt devpts -o gid=5,mode=620 devpts ${CLFS}/dev/pts
mount -vt proc proc ${CLFS}/proc
mount -vt tmpfs tmpfs ${CLFS}/run
mount -vt sysfs sysfs ${CLFS}/sys

[ -h ${CLFS}/dev/shm ] && mkdir -pv ${CLFS}/$(readlink ${CLFS}/dev/shm)

cp -rf * /mnt/clfs/sources

chroot "${CLFS}" /tools/bin/env -i \
    HOME=/root TERM="${TERM}" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h
