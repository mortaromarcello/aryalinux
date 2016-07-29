#!/bin/bash

set -e
set +h

SOURCE_DIR="/sources"

. ./build-properties

if ! grep "config-files" /sources/build-log &> /dev/null
then

cat > /etc/resolv.conf << EOF
# Begin /etc/resolv.conf

domain $DOMAIN_NAME

nameserver 8.8.8.8
nameserver 8.8.4.4

# End /etc/resolv.conf
EOF

echo "$HOST_NAME" > /etc/hostname

cat > /etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1 localhost
::1       localhost

# End /etc/hosts (network card version)
EOF

cat > /etc/udev/rules.d/83-duplicate_devs.rules << "EOF"

# Persistent symlinks for webcam and tuner
KERNEL=="video*", ATTRS{idProduct}=="1910", ATTRS{idVendor}=="0d81", \
    SYMLINK+="webcam"
KERNEL=="video*", ATTRS{device}=="0x036f", ATTRS{vendor}=="0x109e", \
    SYMLINK+="tvtuner"

EOF

cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

cat > /etc/locale.conf << EOF
LANG=$LOCALE
EOF

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line


# End /etc/inputrc
EOF

cat > /etc/vconsole.conf << EOF
KEYMAP=$KEYBOARD
EOF

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

cat > /etc/fstab << EOF
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

$ROOT_PART     /            ext4     defaults            1     1
$SWAP_PART     swap         swap     pri=1               0     0
$HOME_PART     /home        ext4     defaults            1     1

# End /etc/fstab
EOF

if [ "$SWAP_PART" == "" ]
then
	grep -v "swap" /etc/fstab > /etc/fstab1
	rm /etc/fstab
	mv /etc/fstab1 /etc/fstab
fi

if [ "$HOME_PART" == "" ]
then
	grep -v "home" /etc/fstab > /etc/fstab1
	rm /etc/fstab
	mv /etc/fstab1 /etc/fstab
fi

fi

./initramfs.sh
extras/014-openssl.sh

./kernel.sh

for script in extras/*.sh
do
	$script
done

if ! grep "user-and-passwords" /sources/build-log &> /dev/null
then

clear
echo "Setting the password for root :"
passwd root

clear
echo "Creating user with name $FULLNAME and username : $USERNAME"
useradd -m -c "$FULLNAME" -s /bin/bash $USERNAME
echo "Setting the password for $USERNAME :"
passwd $USERNAME
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
groupadd wheel
usermod -a -G wheel $USERNAME

fi
