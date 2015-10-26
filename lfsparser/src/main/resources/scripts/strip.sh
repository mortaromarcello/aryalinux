#!/bin/bash

# export LFS=/mnt/lfs

#chroot ${CLFS} /tools/bin/env -i \
#    HOME=/root TERM=${TERM} PS1='\u:\w\$ ' \
#    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
#    /tools/bin/bash --login
find /mnt/lfs/{,usr/}{bin,lib,sbin} -type f -exec /tools/bin/strip --strip-debug '{}' ';'
