#!/bin/bash

set -e

SOURCE_DIR=/sources
cd $SOURCE_DIR

cat > grub-embedded.cfg <<"EOF"
search --file --set=root /aryalinux/root.sfs
set prefix=($root)/EFI/BOOT/
EOF

grub-mkimage --format=x86_64-efi --output=bootx64.efi --config=grub-embedded.cfg --compression=xz --prefix=/EFI/BOOT part_gpt part_msdos fat ext2 hfs hfsplus iso9660 udf ufs1 ufs2 zfs chain linux boot appleldr ahci configfile normal regexp minicmd reboot halt search search_fs_file search_fs_uuid search_label gfxterm gfxmenu efi_gop efi_uga all_video loadbios gzio echo true probe loadenv bitmap_scale font cat help ls png jpeg tga test at_keyboard usb_keyboard

dd if=/dev/zero of=efiboot.img bs=1K count=1440
mkdosfs -F 12 efiboot.img
MOUNTPOINT=efiboot
mkdir -pv $MOUNTPOINT
mount -o loop efiboot.img $MOUNTPOINT
mkdir -pv $MOUNTPOINT/EFI/BOOT
cp -av bootx64.efi $MOUNTPOINT/EFI/BOOT
umount $MOUNTPOINT
rmdir $MOUNTPOINT

echo "bootx86.efi and efiboot.img created."
