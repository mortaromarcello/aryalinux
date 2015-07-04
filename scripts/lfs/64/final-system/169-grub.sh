#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=grub-2.00.tar.xz

if ! grep 170-grub $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


sed -i -e '/gets is a/d' grub-core/gnulib/stdio.in.h

./configure --prefix=/usr \
    --sysconfdir=/etc --disable-werror

make "-j`nproc`"

make install

install -m755 -dv /etc/default
cat > /etc/default/grub << "EOF"
# Begin /etc/default/grub

GRUB_DEFAULT=0
#GRUB_SAVEDEFAULT=true
GRUB_HIDDEN_TIMEOUT=GRUB_HIDDEN_TIMEOUT_QUIET=false
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=Cross-LFS

GRUB_CMDLINE_LINUX=""
GRUB_CMDLINE_LINUX_DEFAULT=""

#GRUB_TERMINAL=console
#GRUB_GFXMODE=640x480
#GRUB_GFXPAYLOAD_LINUX=keep

#GRUB_DISABLE_LINUX_UUID=true
#GRUB_DISABLE_LINUX_RECOVERY=true

#GRUB_INIT_TUNE="480 440 1"

#GRUB_DISABLE_OS_PROBER=true

# End /etc/default/grub
EOF

cd $SOURCE_DIR
rm -rf $DIR
echo 170-grub >> $LOG

fi
