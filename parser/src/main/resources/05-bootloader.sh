#!/bin/bash

set -e
set +h

export SOURCE_DIR="/sources"
export LOG_PATH="/sources/install-log"

export STEP_NAME="05-bootloader"

touch $LOG_PATH
cd $SOURCE_DIR

if ! grep "$STEP_NAME" $LOG_PATH
then

read -p "Enter the device where you want to install grub : " BOOT_DEV

if [ "x$BOOT_DEV" != "x" ]
then

grub-install $BOOT_DEV

fi

grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null

cd $SOURCE_DIR

echo "$STEP_NAME" >> $LOG_PATH

fi

echo "Execute 6.sh"
