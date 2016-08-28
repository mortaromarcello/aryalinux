#!/bin/bash

set +h

./umountal.sh

set -e

LFS=/mnt/lfs

read -p "Enter the name of the root partition eg. /dev/sda10 : " ROOT_PART
read -p "Enter the name of the home partition eg. /dev/sda11 : " HOME_PART
read -p "Enter the default boot entry in the Live Disk e.g. My Linux : " LABEL
read -p "Enter the name of iso file to be generated e.g. my-linux-live-i686.iso : " OUTFILE
read -p "Which user should be logged in by default ? " USERNAME

mkdir -pv $LFS
mount $ROOT_PART $LFS || exit
if [ "x$HOME_PART" != "x" ]
then
	mount $HOME_PART $LFS/home || exit
fi

if [ ! -d $LFS/sources ]
then
	mkdir -pv $LFS/sources
fi

cp -v create-efiboot.img.sh $LFS/sources
cp -v install-grub.sh $LFS/sources
cp -v mkliveinitramfs.sh $LFS/sources
cp -v init.sh $LFS/sources

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

if [ ! -f $LFS/etc/live-grub-created ]
then
chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/install-grub.sh
touch $LFS/etc/live-grub-created
fi

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/create-efiboot.img.sh

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash /sources/mkliveinitramfs.sh

sleep 5
set +e
./umountal.sh
set -e

mount $ROOT_PART $LFS || exit
if [ "x$HOME_PART" != "x" ]
then
	mount $HOME_PART $LFS/home || exit
fi

if [ -f $LFS/etc/lightdm/lightdm.conf ]
then
	sed -i "s@#autologin-user=@autologin-user=$USERNAME@g" $LFS/etc/lightdm/lightdm.conf
	sed -i "s@#autologin-user-timeout=0@autologin-user-timeout=0@g" $LFS/etc/lightdm/lightdm.conf
	sed -i "s@#pam-service=lightdm-autologin@pam-service=lightdm-autologin@g" $LFS/etc/lightdm/lightdm.conf
else
	mkdir -pv $LFS/etc/systemd/system/getty@tty1.service.d/
	pushd $LFS/etc/systemd/system/getty@tty1.service.d/
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
cd $LFS/sources/

cat > isolinux.cfg << EOF
DEFAULT menu.c32
PROMPT 0
MENU TITLE Select an option to boot Aryalinux
TIMEOUT 300

LABEL slientlive
    MENU LABEL $LABEL
    MENU DEFAULT
    KERNEL /isolinux/vmlinuz
    APPEND initrd=initram.fs quiet splash
LABEL debuglive
    MENU LABEL $LABEL Debug Mode
    KERNEL /isolinux/vmlinuz
    APPEND initrd=initram.fs
EOF

tar xf $LFS/sources/syslinux-4.06.tar.xz
rm -fr live
mkdir -pv live/EFI/BOOT
mkdir -pv live/isolinux
mkdir -pv live/aryalinux

cp -v syslinux-4.06/core/isolinux.bin live/isolinux
cp -v syslinux-4.06/com32/menu/menu.c32 live/isolinux

mv isolinux.cfg live/isolinux/
cp -v $LFS/sources/root.sfs live/aryalinux/
cp -v `ls $LFS/boot/vmlinuz*`   live/isolinux/vmlinuz
cp -v $LFS/boot/initram.fs live/isolinux/
cp -v $LFS/sources/efiboot.img live/isolinux/
cp -v $LFS/sources/bootx64.efi live/EFI/BOOT/
cp -v $LFS/sources/grub-embedded.cfg live/EFI/BOOT/

echo "AryaLinux Live" > live/isolinux/id_label

cat > live/EFI/BOOT/grub.cfg << EOF
set default="0"
set timeout="30"
set hidden_timeout_quiet=false

#if loadfont /EFI/boot/unicode.pf2; then
#  set gfxmode=800x600
#  load_video
#fi

#terminal_output gfxterm

menuentry "$LABEL"{
  echo "Loading AryaLinux.  Please wait..."
  linux /isolinux/vmlinuz quiet splash
  initrd /isolinux/initram.fs
}

menuentry "$LABEL Debug Mode"{
  linux /isolinux/vmlinuz
  initrd /isolinux/initram.fs
}
EOF

#mkisofs -o $LFS/sources/$OUTFILE -R -J -A "$LABEL" -hide-rr-moved -v -d -N -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/isolinux.boot -eltorito-alt-boot -no-emul-boot -eltorito-platform 0xEF -eltorito-boot isolinux/efiboot.img -V "ARYALIVE" live


xorriso -as mkisofs -o $LFS/sources/$OUTFILE -isohybrid-mbr $LFS/sources/syslinux-4.06/mbr/isohdpfx.bin -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e isolinux/efiboot.img -no-emul-boot -isohybrid-gpt-basdat live

