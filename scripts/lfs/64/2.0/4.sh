#!/bin/bash

set -e
set +h

export SOURCES=/sources
export BUILD_LOG=/sources/build-log

. inputs

if [ ! -f /etc/adjtime ]
then

cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

fi

if [ ! -f /etc/profile ]
then

cat > /etc/profile << "EOF"
# Begin /etc/profile

source /etc/locale.conf

for f in /etc/bash_completion.d/*
do
  if [ -e ${f} ]; then source ${f}; fi
done
unset f

export INPUTRC=/etc/inputrc

# End /etc/profile
EOF

fi

if [ ! -f /etc/locale.conf ]
then

cat > /etc/locale.conf << "EOF"
# Begin /etc/locale.conf

LANG=$LOCALE

# End /etc/locale.conf
EOF

fi

if [ ! -f /etc/inputrc ]
then

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

# All of the following map the escape sequence of the
# value contained inside the 1st argument to the
# readline specific functions

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

fi
if [ ! -f /etc/fstab ]
then

cat > /etc/fstab <<EOF
# Begin /etc/fstab

# file system  mount-point  type   options          dump  fsck
#                                                         order

$ROOT_PART     /            ext4  defaults         1     1
EOF

if [ "x$SWAP_PART" != "x" ]
then
cat >> /etc/fstab<<EOF
$SWAP_PART     swap         swap   pri=1            0     0
EOF
fi

if [ "x$HOME_PART" != "x" ]
then
cat >> /etc/fstab<<EOF
$HOME_PART     /home         ext4   defaults       1     1
EOF
fi

cat >> /etc/fstab<<"EOF"
# End /etc/fstab
EOF

fi

if [ ! -f /etc/hostname ]
then

echo "$HOSTNAME" > /etc/hostname

fi

if [ ! -f /etc/hosts ]
then

cat > /etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1 localhost
# Host entries go here...

# End /etc/hosts (network card version)
EOF

fi

if [ ! -f /etc/resolv.conf ]
then

cat > /etc/resolv.conf <<EOF
# Begin /etc/resolv.conf

domain $DOMAIN
nameserver $PRIMARY_DNS
nameserver $SEC_DNS

# End /etc/resolv.conf
EOF

fi

if [ ! -f /etc/systemd/network/dhcp.network ]
then

cd /etc/systemd/network &&
cat > dhcp.network << "EOF"
[Match]
Name=enp2s0

[Network]
DHCP=yes
EOF

fi

if ! grep "systemd-timesync" /etc/passwd
then

groupadd -g 41 systemd-timesync
useradd -g systemd-timesync -u 41 -d /dev/null -s /bin/false systemd-timesync

systemctl enable systemd-timesyncd

fi

if ! grep "network-scripts" $BUILD_LOG
then

cd /sources
tar -xf clfs-network-scripts-20140224.tar.xz
cd clfs-network-scripts-20140224

make install

cd /sources
rm -rf clfs-network-scripts-20140224

echo "network-scripts" >> $BUILD_LOG
fi

if ! grep "kernel" $BUILD_LOG
then

tar -xf linux-3.14.21.tar.xz
cd linux-3.14.21

for patch in ../aufs3-*.patch
do
	patch -Np1 -i $patch
done

tar -xf ../aufs3.tar.gz
cp ../config ./.config

make "-j`nproc`"
make modules_install
make firmware_install
cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-clfs-3.14.21
cp -v System.map /boot/System.map-3.14.21
cp -v .config /boot/config-3.14.21

cd /sources
rm -rf linux-3.14.21

echo "kernel" >> $BUILD_LOG
fi

if ! grep "firmware" $BUILD_LOG
then

tar -xf linux-firmware-master.tar.gz -C /lib/modules

echo "firmware" >> $BUILD_LOG
fi

if [ ! -f "/etc/clfs-release" ]
then

echo 3.0.0-SYSTEMD > /etc/clfs-release

fi

clear

echo "Done with building the base system. Now lets put some essential packages before rebooting"
echo "Execute 5.sh by entering the following below:"
echo "./5.sh"
