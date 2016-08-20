#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="008-bootloader.sh"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ -d /sys/firmware/efi ]
then

EFIPART="$DEV_NAME`partx -s $DEV_NAME | tr -s ' ' | grep "EFI" | sed "s@^ *@@g" | cut "-d " -f1`"
mkdir -pv /boot/efi

{
set +e
mount -vt vfat $EFIPART /boot/efi
set -e
}

cat >> /etc/fstab <<EOF
$EFIPART       /boot/efi    vfat     defaults            0     1
efivarfs       /sys/firmware/efi/efivars  efivarfs  defaults  0      1
EOF

grub-install --target=`uname -m`-efi --efi-directory=/boot/efi  \
   --bootloader-id="$OS_NAME $OS_VERSION $OS_CODENAME" --recheck --debug

grub-mkconfig -o /boot/grub/grub.cfg

else

grub-install $DEV_NAME
grub-mkconfig -o /boot/grub/grub.cfg

fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
