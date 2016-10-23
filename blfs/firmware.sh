#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:postlfs

whoami > /tmp/currentuser





NAME="firmware"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi



URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make


head -n7 /proc/cpuinfo


mkdir -pv /lib/firmware/intel-ucode
cp -v <XX-YY-ZZ> /lib/firmware/intel-ucode


mkdir -pv /lib/firmware/amd-ucode
cp -v microcode_amd* /lib/firmware/amd-ucode


mkdir -p initrd/kernel/x86/microcode
cd initrd


cp -v /lib/firmware/amd_ucode/<MYCONTAINER> kernel/x86/microcode/AuthenticAMD.bin


cp -v /lib/firmware/intel-ucode/<XX-YY-ZZ> kernel/x86/microcode/GenuineIntel.bin


find . | cpio -o -H newc > /boot/microcode.img


initrd /microcode.img


initrd /boot/microcode.img


mkdir -pv /lib/firmware/radeon
cp -v <YOUR_BLOBS> /lib/firmware/radeon


wget https://raw.github.com/imirkin/re-vp2/master/extract_firmware.py
wget http://us.download.nvidia.com/XFree86/Linux-x86/325.15/NVIDIA-Linux-x86-325.15.run
sh NVIDIA-Linux-x86-325.15.run --extract-only
python extract_firmware.py 
mkdir -p /lib/firmware/nouveau
cp -d nv* vuc-* /lib/firmware/nouveau/




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
