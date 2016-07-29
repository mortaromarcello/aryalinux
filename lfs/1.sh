#!/bin/bash

set -e
set +h

RED='\033[0;31m'
NC='\033[0m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'

clear
echo -e "Welcome to the ${ORANGE}Arya${GREEN}Linux${NC} Builder."
echo -e "${NC}"
echo -e "${RED}Please note that if you have hibernate your existing Linux system and you are specifying the swap partition while building AryaLinux, you would not be able to resume from hibernation in the existing Linux system. This would not be a problem however if you either don't have another Linux installed or if that has been shutdown and not hibernated or if you do not use a swap partition at all."
echo -e "${NC}"

if [ ! -f ./build-properties ]
then

echo "Build/Installation Information:"
read -p "Enter device name e.g. /dev/sda : " DEV_NAME
read -p "Enter the root partition e.g. /dev/sda10 : " ROOT_PART
read -p "Enter the swap partition e.g. /dev/sda11 : " SWAP_PART
read -p "Enter the home partition e.g. /dev/sda12 : " HOME_PART

clear
echo "Computer and User Information:"
read -p "Enter the hostname(Computer name) : " HOST_NAME
read -p "Enter your full name " FULLNAME
read -p "Enter the username for $FULLNAME " USERNAME
read -p "Enter the domain name(Domain to which this computer would be added) e.g. aryalinux.org : " DOMAIN_NAME

clear
echo "OS Name, Version and Codename:"
read -p "Enter OS Name e.g. AryaLinux : " OS_NAME
read -p "Enter OS Codename : " OS_CODENAME
read -p "Enter OS Version e.g. 2016.04 : " OS_VERSION

clear
echo "General Information about building:"
read -p "Enter locale e.g. en_IN.utf8 : " LOCALE
read -p "Enter paper size (A4/letter) : " PAPER_SIZE
read -p "Do you want to build using multiple processors? (y/n) " MULTICORE
read -p "Enter the keyboard type e.g. us : " KEYBOARD

clear
TIMEZONE=`tzselect`

cat > build-properties << EOF
DEV_NAME="$DEV_NAME"
ROOT_PART="$ROOT_PART"
SWAP_PART="$SWAP_PART"
HOME_PART="$HOME_PART"
OS_NAME="$OS_NAME"
OS_CODENAME="$OS_CODENAME"
OS_VERSION="$OS_VERSION"
LOCALE="$LOCALE"
PAPER_SIZE="$PAPER_SIZE"
HOST_NAME="$HOST_NAME"
TIMEZONE="$TIMEZONE"
DOMAIN_NAME="$DOMAIN_NAME"
MULTICORE="$MULTICORE"
FULLNAME="$FULLNAME"
USERNAME="$USERNAME"
KEYBOARD="$KEYBOARD"
EOF

fi

. ./build-properties

mkfs -v -t ext4 $ROOT_PART

export LFS=/mnt/lfs

mkdir -pv $LFS
mount -v -t ext4 $ROOT_PART $LFS

if [ "$HOME_PART" != "" ]
then
	mkdir -v $LFS/home
	mount -v -t ext4 $HOME_PART $LFS/home
fi


if [ "$SWAP_PART" != "" ]
then
	mkswap $SWAP_PART
	/sbin/swapon -v $SWAP_PART
fi

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
if [ -d ../sources ]
then
	cp ../sources/* $LFS/sources/
fi

rm -rf /sources
ln -svf $LFS/sources /
chmod -R a+rw /sources

rm -rf /tools
mkdir -v $LFS/tools
ln -sv $LFS/tools /

if grep "lfs" /etc/passwd &> /dev/null
then
	userdel -r lfs &> /dev/null
fi

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

chmod a+x *.sh
chmod a+x resume
chmod a+x toolchain/*.sh
chmod a+x final-system/*.sh

cp -r * /home/lfs/
cp -r * /sources
chown -R lfs:lfs /home/lfs/*

chmod a+x /home/lfs/*.sh

clear
echo "Entering lfs user. Please execute 2.sh by entering the following command below:"
echo "./2.sh"

cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/lfs/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

su - lfs

chown -R root:root $LFS/tools


mkdir -pv $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

cp -v resume /tools/bin/resume
chmod a+x /tools/bin/resume

clear
echo "Would chroot into the toolchain."
echo "To continue enter the following command below:"
echo "resume"

chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='\u:\w\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h

rm -rf /tmp/*

clear
echo "Once again chrooting to build the kernel and install bootloader"
echo "Please execute 4.sh by entering the following command below:"
echo "./4.sh"

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login

echo "Cleaning up..."

rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libz.a


