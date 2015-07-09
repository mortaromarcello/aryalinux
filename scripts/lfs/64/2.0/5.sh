#!/bin/bash

set -e
set +h

. inputs

export SOURCE_DIR=/sources
export INSTALL_LOG=$SOURCE_DIR/build-log

cd $SOURCE_DIR
touch $INSTALL_LOG

clear

echo "Please enter the root password :"
passwd root

clear

echo "Now creating a user for you..."
useradd -m -c "$FULLNAME" -s /bin/bash $USERNAME
echo "Please enter the password for $USERNAME :"
passwd $USERNAME


read -p "Please enter the device name where you want to install the bootloader (e.g. /dev/sda ) : " DEVICE
echo "Installing bootloader..."

grub-install $DEVICE

read -p "Let's give a name to your operating system. What name would you like? " NAME
read -p "What version of $NAME is this? " VERSION
read -p "Give a nickname to $NAME version $VERSION " CODENAME

cat > /etc/lsb-release <<EOF
DISTRIB_ID="$NAME"
DISTRIB_RELEASE="$VERSION"
DISTRIB_CODENAME="$CODENAME"
DISTRIB_DESCRIPTION="$NAME $VERSION $CODENAME"
EOF

for script in postlfs/*.sh
do
	$script
done

sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
usermod -a -G wheel $USERNAME

echo "Done with installation of the system. Please reboot to log into your newly created operating system"
echo "Press Ctrl + Alt + Delete to reboot now"
