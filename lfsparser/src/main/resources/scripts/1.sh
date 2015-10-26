#!/bin/bash

set -e
set +h

clear

echo "Found the following partitions :"
echo ""

fdisk -l | grep '^Device\|^/dev' | sed 's/Device   /Partition/g'

echo ""

read -p "Enter root partition (like /dev/sda1) : " ROOT_PART
read -p "Enter home partition (like /dev/sda2) : " HOME_PART
read -p "Enter swap Partition (like /dev/sda3) : " SWAP_PART
echo ""
read -p "Enter the locale (like en_IN.utf8) : " LOCALE
read -p "Enter the keyboard layout (like fr-latin9 or uk or us etc) : " KEYMAP
read -p "Enter the paper size to be used by groff (A4/letter) : " PAPER_SIZE
echo ""
read -p "Enter your full name : " FULLNAME
read -p "Choose a username for $FULLNAME : " USERNAME
read -p "Enter this computer's name (e.g. $USERNAME-aryalinux) : " HOSTNAME
read -p "Enter the domain name for this network (e.g. aryalinux.org) : " DOMAIN
read -p "Enter the primary DNS (e.g. 8.8.8.8) : " PRIMARY_DNS
read -p "Enter the secondary DNS (e.g. 8.8.4.4) : " SEC_DNS

clear

if [ -z "$ROOT_PART" ]
then
	echo "You need to provide a root partition name. Cannot continue. Please restart the script."
	exit
fi

if [ -z "$USERNAME" ]
then
        echo "You need to provide a username. Cannot continue. Please restart the script."
	exit
fi

echo "Let's figure out your timezone..."
TIMEZONE=`tzselect`

if [ -z "$LOCALE" ]
then
	LOCALE="en_IN.utf8"
fi

if [ -z "$KEYMAP" ]
then
	KEYMAP="us"
fi

if [ -z "$PAPER_SIZE" ]
then
	PAPER_SIZE="A4"
fi

if [ -z "$HOSTNAME" ]
then
	HOSTNAME="$USERNAME-aryalinux"
fi

if [ -z "$DOMAIN" ]
then
	DOMAIN="aryalinux.org"
fi

if [ -z "$PRIMARY_DNS" ]
then
        PRIMARY_DNS="8.8.8.8"
fi

if [ -z "$SEC_DNS" ]
then
        SEC_DNS="8.8.4.4"
fi

clear

echo "Thank you for all the input. Would now start the build process with your inputs."
echo "Should you feel like to stop, press CTRL+C. You can try resuming by re-running the script."
echo "For your reference, the build would start with these inputs:"
echo ""

cat > build.conf <<EOF
SOURCE_DIR=/sources
BUILD_LOG=/sources/build.log

ROOT_PART="$ROOT_PART"
SWAP_PART="$SWAP_PART"
HOME_PART="$HOME_PART"
LOCALE="$LOCALE"
PAPER_SIZE="$PAPER_SIZE"
HOSTNAME="$HOSTNAME"
DOMAIN="$DOMAIN"
PRIMARY_DNS="$PRIMARY_DNS"
SEC_DNS="$SEC_DNS"
FULLNAME="$FULLNAME"
USERNAME="$USERNAME"
KEYMAP="$KEYMAP"
TIMEZONE="$TIMEZONE"
EOF

cat build.conf | sed 's/=/ : /g' | sed 's/"//g'

read -p "Press enter to start. To exit press Ctrl + C " ENTER

export LFS=/mnt/lfs

mkfs.ext4 $ROOT_PART
mkdir -pv ${LFS}
mount -v $ROOT_PART ${LFS}

if [ -n "$HOME_PART" ]
then
        mkfs.ext4 $HOME_PART
        mkdir -pv $LFS/home
	mount -v $HOME_PART $LFS/home 
fi

if [ -n "$SWAP_PART" ] && ! `swapon -s`
then
	echo "Turning on swap..."
	swapon $SWAP_PART
fi

echo "Extracting toolchain. This would take a while..."

tar -xf ../toolchain.tar.gz -C $LFS
ln -svf $LFS/tools /

echo "Copying source tarballs. This would take a while..."

cp -rf ../sources $LFS/

chmod -v a+wt ${LFS}/sources

cp -rf * $LFS/sources

mkdir -pv ${LFS}/{dev,proc,run,sys}

mknod -m 600 ${LFS}/dev/console c 5 1
mknod -m 666 ${LFS}/dev/null c 1 3

mount -v -o bind /dev ${LFS}/dev

mount -vt devpts -o gid=5,mode=620 devpts ${LFS}/dev/pts
mount -vt proc proc ${LFS}/proc
mount -vt tmpfs tmpfs ${LFS}/run
mount -vt sysfs sysfs ${LFS}/sys

[ -h ${LFS}/dev/shm ] && mkdir -pv ${LFS}/$(readlink ${LFS}/dev/shm)

sed -i 's@BUILD_LOG=\$LFS/sources/build.log@BUILD_LOG=/sources/build.log@g' build.conf
sed -i 's@SOURCE_DIR=\$LFS/sources@SOURCE_DIR=/sources@g' build.conf

clear

echo "Sources and scripts ready! Would now chroot into the toolchain."
echo "Please change to the /sources directory and execute 2.sh by entering the following commands :"
echo "cd /sources"
echo "./2.sh"

chroot "${LFS}" /tools/bin/env -i \
    HOME=/root TERM="${TERM}" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /sources/2.sh


umount /mnt/lfs/dev/pts
umount /mnt/lfs/dev
umount /mnt/lfs/sys
umount /mnt/lfs/proc
umount /mnt/lfs/run

./strip.sh

clear

echo "Done building the base system. You can reboot and choose the new Linux you built."
