#!/bin/bash

set -e
set +h

( ./umountal.sh && echo "Unmounted partition before performing actions..." ) || ( echo "Nothing mounted. Continuing..." )

. ./build-properties

export LFS=/mnt/lfs
mkdir -pv $LFS
mount $ROOT_PART $LFS

cat > $LFS/tools/bin/stripdebug <<EOF
/tools/bin/find /usr/lib -type f -name \*.a \
   -exec /tools/bin/strip --strip-debug {} ';'

/tools/bin/find /lib /usr/lib -type f -name \*.so* \
   -exec /tools/bin/strip --strip-unneeded {} ';'

/tools/bin/find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
    -exec /tools/bin/strip --strip-all {} ';'

EOF

chmod a+x $LFS/tools/bin/stripdebug

chroot $LFS /tools/bin/env -i            \
    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin   \
    /tools/bin/bash --login /tools/bin/stripdebug

rm $LFS/tools/bin/stripdebug
umount $LFS

sleep 5

mount $ROOT_PART $LFS
mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/fix-grub.sh

./umountal.sh
