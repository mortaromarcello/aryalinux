#!/bin/bash

set -e
set +h

export SOURCE_DIR="/sources"
export LOG_PATH="/sources/build-log"

export STEP_NAME="05-bootloader"

touch $LOG_PATH
cd $SOURCE_DIR

if ! grep "$STEP_NAME" $LOG_PATH
then

grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null

cd $SOURCE_DIR

echo "$STEP_NAME" >> $LOG_PATH

fi
