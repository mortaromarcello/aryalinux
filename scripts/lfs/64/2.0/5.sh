#!/bin/bash

set -e
set +h

. inputs

export SOURCE_DIR=/sources
export INSTALL_LOG=$SOURCE_DIR/install-log

cd $SOURCE_DIR
touch $INSTALL_LOG

echo "Please enter the root password :"
passwd root

echo "Now creating a user for you..."
useradd -m -c "$FULLNAME" -s /bin/bash $USERNAME
echo "Please enter the password for $USERNAME :"
passwd $USERNAME


read -p "Please enter the device name where you want to install the bootloader (e.g. /dev/sda ) : " DEVICE
echo "Installing bootloader..."

grub-install $DEVICE

for script in postlfs/*.sh
do
	$script
done

sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
usermod -a -G wheel $USERNAME

echo "Done with installation of the system. Please reboot to log into your newly created operating system"
echo "Press Ctrl + Alt + Delete to reboot now"
