#!/bin/bash

set -e
set +h

SOURCE_DIR="/sources"

. /sources/build-properties

if ! grep "config-files" /sources/build-log &> /dev/null
then

if [ ! -e /etc/udev/rules.d/70-persistent-net.rules ]; then
    bash /lib/udev/init-net-rules.sh
fi

cat > /etc/sysconfig/ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.1.26
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=192.168.1.255
EOF


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

cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF

cat > /etc/udev/rules.d/83-duplicate_devs.rules << "EOF"

# Persistent symlinks for webcam and tuner
KERNEL=="video*", ATTRS{idProduct}=="1910", ATTRS{idVendor}=="0d81", \
    SYMLINK+="webcam"
KERNEL=="video*", ATTRS{device}=="0x036f", ATTRS{vendor}=="0x109e", \
    SYMLINK+="tvtuner"

EOF

cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock
UTC=1
# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=
# End /etc/sysconfig/clock
EOF

cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console
KEYMAP="$KEYBOARD"
# End /etc/sysconfig/console
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

if [ "x$ROOT_PART" != "x" ]; then
ROOT_PART_BY_UUID=$(blkid $ROOT_PART | cut -d\" -f2)
fi

if [ "x$SWAP_PART" != "x" ]; then
SWAP_PART_BY_UUID=$(blkid $SWAP_PART | cut -d\" -f2)
fi

if [ "x$HOME_PART" != "x" ]; then
HOME_PART_BY_UUID=$(blkid $HOME_PART | cut -d\" -f2)
fi

cat > /etc/fstab << EOF
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

UUID=$ROOT_PART_BY_UUID     /            ext4     defaults            1     1
EOF

if [ "x$SWAP_PART_BY_UUID" != "x" ]
then
cat >> /etc/fstab <<EOF
UUID=$SWAP_PART_BY_UUID     swap         swap     pri=1               0     0
EOF
fi

if [ "x$HOME_PART_BY_UUID" != "x" ]
then
cat >> /etc/fstab <<EOF
UUID=$HOME_PART_BY_UUID     /home        ext4     defaults            1     1
EOF
fi

cat >> /etc/fstab <<EOF

# End /etc/fstab
EOF

fi

#if ! grep initramfs /sources/build-log &> /dev/null
#then
#	/sources/initramfs.sh
#fi

#if ! grep "014-openssl.sh" /sources/build-log &> /dev/null
#then
#	/sources/extras/014-openssl.sh
#fi

#/sources/lvm2.sh

if ! grep kernel /sources/build-log &> /dev/null
then
	/sources/kernel.sh
fi

#for script in /sources/extras/*.sh
#do
#	$script
#done

if ! grep syslinux /sources/build-log &> /dev/null
then

cd $SOURCE_DIR
tar xf syslinux-4.06.tar.xz
cd syslinux-4.06
cd utils
make
cp isohybrid /usr/bin/
cd $SOURCE_DIR
rm -r syslinux-4.06

echo "syslinux" >> /sources/build-log

fi

if ! grep "admin-user" /sources/build-log &> /dev/null
then

echo "Creating user with name $FULLNAME and username : $USERNAME"
useradd -m -c "$FULLNAME" -s /bin/bash $USERNAME
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
groupadd wheel
usermod -a -G wheel $USERNAME

echo "admin-user" >> /sources/build-log

fi
