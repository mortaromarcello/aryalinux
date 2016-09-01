#!/bin/bash

set -e

SOURCE_DIR=/sources

cd $SOURCE_DIR

LABEL="$1"

rm -vf grub-embedded.cfg
rm -vf efiboot.img

dd if=/dev/zero of=efiboot.img bs=1K count=1440
mkdosfs -F 12 efiboot.img
MOUNTPOINT=$(mktemp -d)
mount -o loop efiboot.img $MOUNTPOINT
mkdir -p $MOUNTPOINT/EFI/BOOT
cp -a bootx64.efi $MOUNTPOINT/EFI/BOOT
cat > $MOUNTPOINT/EFI/BOOT/grub.cfg << EOF
set default="0"
set timeout="30"
set hidden_timeout_quiet=false

menuentry "$LABEL"{
  echo "Loading AryaLinux.  Please wait..."
  linux /isolinux/vmlinuz quiet splash
  initrd /isolinux/initram.fs
}

menuentry "$LABEL Debug Mode"{
  echo "Loading AryaLinux in debug mode.  Please wait..."
  linux /isolinux/vmlinuz
  initrd /isolinux/initram.fs
}
EOF
cp $MOUNTPOINT/EFI/BOOT/grub.cfg .

umount $MOUNTPOINT
rmdir $MOUNTPOINT

