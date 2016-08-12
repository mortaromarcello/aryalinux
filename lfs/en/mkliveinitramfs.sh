#!/bin/bash

set -e

cd /sources
echo "AryaLinux Live" >id_label
mkdir -pv mnt_init/{bin,boot}
cp -v id_label mnt_init/boot
cp -v /bin/busybox mnt_init/bin
cp init.sh mnt_init/init
sed -i "s/<ARCH>/$(uname -m)/g" mnt_init/init
chmod +x mnt_init/init

pushd mnt_init
find . | ./bin/busybox cpio -o -H newc -F ../initramfs.cpio
popd
gzip -9 initramfs.cpio
rm -rf mnt_init
mv initramfs.cpio.gz /boot/initram.fs
mv id_label /boot

dd if=/dev/zero bs=1M count=50 of=efiboot.img
mkfs.fat -n "ARCHISO_EFI" efiboot.img
mkdir -pv new
mount -t vfat -o loop efiboot.img new

LINUX_VERSION=`ls /boot/vmlinuz* | sed "s@/boot/vmlinuz-@@g"`

cp -r /boot/vmlinuz-$LINUX_VERSION new/vmlinuz.efi
umount new
rm -rf new
