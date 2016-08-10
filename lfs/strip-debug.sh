#!/bin/bash

set -e
set +h

read -p "Enter the root partition name for AryaLinux : " ROOT_PART

export LFS=/mnt/lfs
mkdir -pv $LFS
mount $ROOT_PART $LFS

echo "Would be chrooting now. At the prompt please run:"
echo "stripdebug"
echo "and hit enter. You might see a lot of messages scroll by. That's normal."

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
    /tools/bin/bash --login

rm $LFS/tools/bin/stripdebug
umount $LFS

echo "Stripping done. Rebuilding grub because grub is not meant to be stripped. Else results in a boot-time warning."

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/fix-grub.sh

clear
echo "Done stripping debug symbols and rebuilding grub."
