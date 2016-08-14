#!/bin/bash

( echo "Unmounting /mnt/lfs if mounted." && ./umountal.sh ) || ( echo "Done" )

read -p "Enter the name of the Root Partition e.g. /dev/sda10 : " ROOT_PART
read -p "Enter the name of the home partition e.g. /dev/sda11 : " HOME_PART
read -p "Enter the default boot entry in the Live Disk : " LABEL
read -p "Enter the name of iso file to be generated : " OUTFILE

export LFS=/mnt/lfs
mount $ROOT_PART $LFS

if [ "x$HOME_PART" != "x" ]
then
	mount $HOME_PART $LFS/home
fi

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

. $LFS/sources/build-properties

KERNEL_VERSION=`ls $LFS/boot/vmlinuz* | rev | cut -d/ -f1 | rev | sed 's@vmlinuz-@@g'`

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/mkliveinitramfs.sh

./umountal.sh
mount $ROOT_PART $LFS

cd $HOME

read -p "Which user should be logged in by default ? " USERNAME
if [ -f $LFS/etc/lightdm/lightdm.conf ]
then
	sed -i "s@#autologin-user=@autologin-user=$USERNAME@g" $LFS/etc/lightdm/lightdm.conf
	sed -i "s@#autologin-user-timeout=0@autologin-user-timeout=0@g" $LFS/etc/lightdm/lightdm.conf
	sed -i "s@#pam-service=lightdm-autologin@pam-service=lightdm-autologin@g" $LFS/etc/lightdm/lightdm.conf
else
	mkdir -pv /etc/systemd/system/getty@tty1.service.d/
	pushd /etc/systemd/system/getty@tty1.service.d/
cat >override.conf<<EOF
[Service]
Type=simple
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear %I 38400 linux
EOF
	popd
fi

rm -f $LFS/sources/root.sfs

sudo mksquashfs $LFS $LFS/sources/root.sfs -b 1048576 -comp xz -Xdict-size 100% -e $LFS/sources -e $LFS/var/cache/alps/sources/* -e $LFS/tools -e $LFS/etc/fstab

if [ -f $LFS/etc/lightdm/lightdm.conf ]
then
	sed -i "s@autologin-user=$USERNAME@#autologin-user=@g" $LFS/etc/lightdm/lightdm.conf
	sed -i "s@autologin-user-timeout=0@#autologin-user-timeout=0@g" $LFS/etc/lightdm/lightdm.conf
        sed -i "s@pam-service=lightdm-autologin@#pam-service=lightdm-autologin@g" $LFS/etc/lightdm/lightdm.conf
else
	rm -fv /etc/systemd/system/getty@tty1.service.d/override.conf
fi
cd $HOME

cat > isolinux.cfg << EOF
DEFAULT menu.c32
PROMPT 0
MENU TITLE Select an option to boot Aryalinux
TIMEOUT 300

LABEL live
    MENU LABEL $LABEL
    MENU DEFAULT
    KERNEL /boot/$(uname -m)/vmlinuz
    APPEND initrd=/boot/$(uname -m)/initram.fs quiet
EOF

sudo tar xf $LFS/sources/syslinux-4.06.tar.xz
rm -fr live
mkdir -p live/boot/{isolinux,$(uname -m)}
mkdir -p live/boot/aryaiso/
cp -v syslinux-4.06/core/isolinux.bin live/boot/isolinux
cp -v syslinux-4.06/com32/menu/menu.c32 live/boot/isolinux
mv -v isolinux.cfg                 live/boot/isolinux

cp -v $LFS/sources/root.sfs live/boot/$(uname -m)
cp -v $LFS/boot/vmlinuz-$KERNEL_VERSION   live/boot/$(uname -m)/vmlinuz
cp -v $LFS/boot/id_label live/boot/$(uname -m)
cp -v $LFS/boot/initram.fs live/boot/$(uname -m)/initram.fs

cp -v $LFS/sources/efiboot.img live/boot/aryaiso/

genisoimage \
  -o "$LFS/sources/$OUTFILE" \
  -c boot.cat \
  -b boot/isolinux/isolinux.bin \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -joliet -l -R \
  -eltorito-alt-boot \
  live

rm -rf live
rm $LFS/boot/initram.fs
rm $LFS/boot/id_label

echo "Making ISO Hybrid. You can simply use dd to write the iso onto a pen drive to create a bootable pen drive."

isohybrid "$LFS/sources/$OUTFILE"
~/scripts/en/umountal.sh

echo "Done creating the live disk. You can find the Live ISO image in the /sources directory of the newly built system (in $ROOT_PART)."
