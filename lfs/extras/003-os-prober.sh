#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="003-os-prober.sh"
TARBALL="os-prober_1.71.tar.xz"
LOGLINES="35"

echo "$LOGLINES" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

make
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

cat > /etc/default/grub << "EOF"
# If you change this file, run grub-mkconfig -o /boot/grub/grub.cfg
# afterwards to update /boot/grub/grub.cfg.

GRUB_DEFAULT="0"
GRUB_SAVE_DEFAULT="true"
#GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET="false"
GRUB_TIMEOUT="10"
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo AryaLinux`
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX=""

# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console

# Select the terminal output device. You may select multiple devices here,
# separated by spaces.
# Valid terminal output names depend on the platform, but may include ‘console’
# (PC BIOS and EFI consoles), ‘serial’ (serial terminal), ‘gfxterm’ (graphics-mode
# output), ‘ofconsole’ (Open Firmware console), or ‘vga_text’ (VGA text output,
# mainly useful with Coreboot).
# The default is to use the platform's native terminal output. 
GRUB_TERMINAL_OUTPUT="gfxterm"

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command `vbeinfo'
GRUB_GFXMODE="1024x768x32"

# If graphical video support is required, either because the ‘gfxterm’ graphical
# terminal is in use or because ‘GRUB_GFXPAYLOAD_LINUX’ is set, then grub-mkconfig
# will normally load all available GRUB video drivers and use the one most
# appropriate for your hardware. If you need to override this for some reason,
# then you can set this option. After grub-install has been run, the available
# video drivers are listed in /boot/grub/video.lst. 
GRUB_VIDEO_BACKEND="vbe"

# Uncomment to select a font to use
GRUB_FONT_PATH="/boot/grub/DejaVuSansMono.pf2"

# Set a background image for use with the ‘gfxterm’ graphical terminal. The value
# of this option must be a file readable by GRUB at boot time, and it must end
# with .png, .tga, .jpg, or .jpeg. The image will be scaled if necessary to fit
# the screen.
#GRUB_BACKGROUND="/usr/share/grub_backgrounds/magnetar_1024x768.jpg"

# Set to ‘text’ to force the Linux kernel to boot in normal text mode, ‘keep’ to
# preserve the graphics mode set using ‘GRUB_GFXMODE’, ‘widthxheight’[‘xdepth’] to
# set a particular graphics mode, or a sequence of these separated by commas or
# semicolons to try several modes in sequence. See gfxpayload.
#
# Depending on your kernel, your distribution, your graphics card, and the phase of
# the moon, note that using this option may cause GNU/Linux to suffer from various 
# display problems, particularly during the early part of the boot sequence. If you
# have problems, set this option to ‘text’ and GRUB will tell Linux to boot in
# normal text mode. 
GRUB_GFXPAYLOAD_LINUX="keep"

# Uncomment if you don't want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true

# Uncomment to disable generation of recovery mode menu entrys
#GRUB_DISABLE_LINUX_RECOVERY="true"
EOF

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
