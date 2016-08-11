#!/bin/bash

set -e
set +h

RED='\033[0;31m'
NC='\033[0m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'

function get_blk_id()
{
	BLKID=`blkid $1 | cut '-d"' -f2`
	echo $BLKID
}

clear
if [ ! -f /tmp/updated ]
then

echo -e "Welcome to the ${ORANGE}Arya${GREEN}Linux${NC} Builder."
echo -e "${NC}"
echo -e "${GREEN}AryaLinux Base System Build Scripts"
echo -e "Copyright (C) 2015-16  Chandrakant Singh"

echo -e "This program is free software: you can redistribute it and/or modify"
echo -e "it under the terms of the GNU General Public License as published by"
echo -e "the Free Software Foundation, either version 3 of the License, or"
echo -e "(at your option) any later version."
echo ""
echo -e "This program is distributed in the hope that it will be useful,"
echo -e "but WITHOUT ANY WARRANTY; without even the implied warranty of"
echo -e "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"
echo -e "GNU General Public License for more details."

echo -e "You should have received a copy of the GNU General Public License"
echo -e "along with this program.  If not, see <http://www.gnu.org/licenses/>."
echo -e "${NC}"

fi

{
 if [ ! -f /tmp/updated ]
 then
  echo "Would now go online and check for updated scripts. If you are not connected to the internet, please connect and press enter to continue..."
  read RESPONSE
  echo "Fetching updates on the build scripts..."
  rm -rf /tmp/2016.08.zip
  rm -rf /tmp/aryalinux-2016.08
  wget https://github.com/FluidIdeas/aryalinux/archive/2016.08.zip -O /tmp/2016.08.zip
  pushd /tmp &> /dev/null
  unzip 2016.08.zip &> /dev/null
  cp -rf aryalinux-2016.08/lfs/* /root/scripts/
  popd &> /dev/null
  clear
  echo "Updated the build scripts successfully."
  echo "Checking sanity of the tarballs. In case some tarballs are missing they would be downloaded now. Please be patient."
  ./download-sources.sh &> /dev/null
  ./additional-downloads.sh &> /dev/null
  touch /tmp/updated
  echo "Done with downloading the updated scripts. Please re-run this script by running ./1.sh"
  exit
 fi
} || {
 echo "2."
 echo "Could not download the latest build scripts. Maybe you're not connected to the internet. You can either continue without the latest scripts or exit, connect to the internet and restart this script once connected so that I can download the updates."
 read -p "Do you want to continue without the updates? (y/n) : " RESPONSE
 if [ "x$RESPONSE" == "xn" ] || [ "x$RESPONSE" == "xN" ]
 then
  exit
 fi
}

echo "Build/Installation Information:"
read -p "Enter device name e.g. /dev/sda. Please note its /dev/sda and not /dev/sda1 or /dev/sda2 etc.. : " DEV_NAME
read -p "Enter the root partition e.g. /dev/sda1 or /dev/sda2 etc. I would make a filesystem on it. So all data in this partition would be erased. Backup any data that's important. : " ROOT_PART
read -p "Enter the swap partition e.g. /dev/sda1 or /dev/sda2 etc. This partition should ideally be of size twice the size of RAM you have. For instance for 2GB RAM swap partition should be of size 4GB. I would format this partition so data in this partition would get lost. Backup any data that's important. : " SWAP_PART
read -p "Enter the home partition e.g. /dev/sda1 or /dev/sda2 etc. This is where your data would be stored. I would format this partition so data in this partition would get lost. Backup any data that's important : " HOME_PART

clear
echo "Computer and User Information:"
read -p "Enter the hostname(Computer name) : " HOST_NAME
read -p "Enter your full name (Spaces allowed) : " FULLNAME
read -p "Enter the username for $FULLNAME (No special characters please) : " USERNAME
read -p "Enter the domain name(Domain to which this computer would be added) e.g. aryalinux.org : " DOMAIN_NAME

clear
echo "OS Name, Version and Codename:"
read -p "Enter OS Name e.g. AryaLinux : " OS_NAME
read -p "Enter OS Codename e.g. Saavan : " OS_CODENAME

clear
echo "General Information about building:"
read -p "Enter locale e.g. en_IN.utf8 : " LOCALE
read -p "Enter paper size (A4/letter) : " PAPER_SIZE
read -p "Do you want to build using multiple processors? (y/n). If you enter y here the build would complete soon but you system would have to stress a lot. If you say n here, build would take longer but system would not stress as much. Does not matter if you have a single core processor though. " MULTICORE
read -p "Enter the keyboard type e.g. us or fr etc. : " KEYBOARD

clear
TIMEZONE=`tzselect`

cat > build-properties << EOF
DEV_NAME="$DEV_NAME"
ROOT_PART="$ROOT_PART"
SWAP_PART="$SWAP_PART"
HOME_PART="$HOME_PART"
OS_NAME="$OS_NAME"
OS_CODENAME="$OS_CODENAME"
OS_VERSION="2016.08"
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

echo "These are the parameters that I would use to build:"
echo ""
cat build-properties
echo ""
echo "If everything looks fine press enter and I would start the build process. Or else to cancel press Ctrl + C and you may later restart the script by entering ./1.sh"
read RESPONSE

mkfs -v -t ext4 $ROOT_PART

export LFS=/mnt/lfs

mkdir -pv $LFS
mount -v -t ext4 $ROOT_PART $LFS

if [ "x$HOME_PART" != "x" ]
then
	mkdir -v $LFS/home
fi


if [ "x$SWAP_PART" != "x" ]
then
	mkswap $SWAP_PART
	/sbin/swapon -v $SWAP_PART
fi

ROOT_PART_BY_UUID=$(get_blk_id $ROOT_PART)
if [ "x$HOME_PART" != "x" ]
then
	mkfs -v -t ext4 $HOME_PART
	mount -v -t ext4 $HOME_PART $LFS/home
	HOME_PART_BY_UUID=$(get_blk_id $HOME_PART)
fi

if [ "x$SWAP_PART" != "x" ]
then
	SWAP_PART_BY_UUID=$(get_blk_id $SWAP_PART)
fi

cat >> build-properties << EOF
ROOT_PART_BY_UUID="$ROOT_PART_BY_UUID"
HOME_PART_BY_UUID="$HOME_PART_BY_UUID"
SWAP_PART_BY_UUID="$SWAP_PART_BY_UUID"
EOF

. ./build-properties

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
echo "cd /sources"
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

echo "Base system built successfully! You may now reboot to log into the newly built system and check if everything is looks fine. To build the rest of the system you would have to boot into this builder disk again. In case you face any issue after rebooting you may boot into this Live Media again and follow the documentation at aryalinux.org or post questions at linuxquestions.org for help or you may continue building the rest of the system by following the documentation at aryalinux.org."
echo "Bye!"
