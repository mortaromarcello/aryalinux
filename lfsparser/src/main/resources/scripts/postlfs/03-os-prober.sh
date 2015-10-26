#!/bin/bash

set -e
set +h

export SOURCE_DIR="/sources"
export LOG_PATH="/sources/build.log"

export STEP_NAME="03-os-prober"
export TARBALL="os-prober_1.63.tar.gz"
export DIRECTORY="os-prober-1.63"

touch $LOG_PATH
cd $SOURCE_DIR

if ! grep "$STEP_NAME" $LOG_PATH
then

tar -xf $TARBALL
cd $DIRECTORY

make "-j`nproc`"
mkdir -pv /usr/{lib,share}/os-prober
cp -v os-prober /usr/bin
cp -v linux-boot-prober /usr/bin
cp -v newns /usr/lib/os-prober
cp -v common.sh /usr/share/os-prober

mkdir -pv /usr/lib/linux-boot-probes/mounted
mkdir -pv /usr/lib/os-probes/{init,mounted}

cp -v linux-boot-probes/common/*         /usr/lib/linux-boot-probes
cp -v linux-boot-probes/mounted/common/* /usr/lib/linux-boot-probes/mounted
cp -v linux-boot-probes/mounted/x86/*    /usr/lib/linux-boot-probes/mounted

cp -v  os-probes/common/*         /usr/lib/os-probes
cp -v  os-probes/init/common/*    /usr/lib/os-probes/init
cp -v  os-probes/mounted/common/* /usr/lib/os-probes/mounted
cp -vR os-probes/mounted/x86/*    /usr/lib/os-probes/mounted

mkdir -pv /var/lib/os-prober

cat > /etc/default/grub <<"EOF"
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo AryaLinux` 
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX="splash quiet"

# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"

# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command 'vbeinfo'
#GRUB_GFXMODE=640x480

# Uncomment if you don't want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true

# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"

# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"
EOF

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEP_NAME" >> $LOG_PATH

fi
