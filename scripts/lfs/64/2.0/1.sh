#!/bin/bash

set -e
set +h

clear

read -p "Enter root partition (like /dev/sda1) : " ROOT_PART
read -p "Enter home partition (like /dev/sda2) : " HOME_PART
read -p "Enter swap Partition (like /dev/sda3) : " SWAP_PART
read -p "Enter the locale (like en_IN.utf-8) : " LOCALE
read -p "Enter the paper size to be used by groff (A4/LETTER) : " PAPER_SIZE
read -p "Enter this computer's name (how would it be identified in the network) : " HOSTNAME
read -p "Enter your full name : " FULLNAME
read -p "Choose a username for $FULLNAME : " USERNAME

clear

echo "Thank you for all the input. Would now start the build process with your inputs."
echo "Should you feel like to stop, press CTRL+C. You can try resuming by re-running the script."
echo "When all the scripts would finish execution, would be creating your user"
echo "This user would have superuser privileges."
echo "After some time, you would be asked for the time zone. Please be ready for that."

read -p "Press enter to start..." ENTER

cat > inputs <<EOF
ROOT_PART="$ROOT_PART"
SWAP_PART="$SWAP_PART"
HOME_PART="$HOME_PART"
LOCALE="$LOCALE"
PAPER_SIZE="$PAPER_SIZE"
HOSTNAME="$HOSTNAME"
FULLNAME="$FULLNAME"
USERNAME="$USERNAME"
EOF

export CLFS=/mnt/clfs

mkfs.ext4 $ROOT_PART
mkdir -pv ${CLFS}
mount -v $ROOT_PART ${CLFS}

if [ "$HOME_PART" != "" ]
then
        mkfs.ext4 $HOME_PART
        mkdir -pv $CLFS/home
	mount -v $HOME_PART $CLFS/home 
fi

echo "Extracting toolchain. This would take a while."

tar -xf ../toolchain.tar.gz -C $CLFS
ln -svf $CLFS/tools /
ln -svf $CLFS/cross-tools /

echo "Copying source tarballs. This would take a while."

cp -rf ../sources $CLFS/
chmod -v a+wt ${CLFS}/sources

cp -rf * $CLFS/sources

mkdir -pv ${CLFS}/{dev,proc,run,sys}

mknod -m 600 ${CLFS}/dev/console c 5 1
mknod -m 666 ${CLFS}/dev/null c 1 3

mount -v -o bind /dev ${CLFS}/dev

mount -vt devpts -o gid=5,mode=620 devpts ${CLFS}/dev/pts
mount -vt proc proc ${CLFS}/proc
mount -vt tmpfs tmpfs ${CLFS}/run
mount -vt sysfs sysfs ${CLFS}/sys

[ -h ${CLFS}/dev/shm ] && mkdir -pv ${CLFS}/$(readlink ${CLFS}/dev/shm)

clear

echo "Sources and scripts ready! Would now chroot into the toolchain."
echo "Please change to the /sources directory and execute 2.sh by entering the following below:"
echo "cd /sources"
echo "./2.sh"

chroot "${CLFS}" /tools/bin/env -i \
    HOME=/root TERM="${TERM}" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h
