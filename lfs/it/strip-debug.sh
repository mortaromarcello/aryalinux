#!/bin/bash

set -e
set +h

( ./umountal.sh && echo "Unmounted partition before performing actions..." ) || ( echo "Nothing mounted. Continuing..." )

read -p "Enter the root partition name for AryaLinux : " ROOT_PART

export LFS=/mnt/lfs
mkdir -pv $LFS
mount $ROOT_PART $LFS

echo "Would be chrooting now. At the prompt please run:"
echo ""
echo "/tools/bin/stripdebug"
echo ""
echo "and hit enter. You might see a lot of messages scroll by. That's normal."

cat > $LFS/tools/bin/stripdebug <<EOF
/tools/bin/find /usr/lib -type f -name \*.a \
   -exec /tools/bin/strip --strip-debug {} ';'

/tools/bin/find /lib /usr/lib -type f -name \*.so* \
   -exec /tools/bin/strip --strip-unneeded {} ';'

/tools/bin/find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
    -exec /tools/bin/strip --strip-all {} ';'

echo "Stripping done. Please enter exit to continue..."

EOF
chmod a+x $LFS/tools/bin/stripdebug

chroot $LFS /tools/bin/env -i            \
    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin   \
    /tools/bin/bash --login

rm $LFS/tools/bin/stripdebug
umount $LFS

echo "Stripping done. Rebuilding grub because grub is not meant to be stripped. Else results in a boot-time warning."

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

clear
./umountal.sh

echo "Done stripping debug symbols and rebuilding grub. In order to build an ISO from the system we just built, run the following command:"
echo ""
echo "./createlivedisk.sh"
echo ""
