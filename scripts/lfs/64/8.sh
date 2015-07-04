cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

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

cat > /etc/locale.conf << "EOF"
# Begin /etc/locale.conf

LANG=en_IN.utf-8

# End /etc/locale.conf
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

cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options          dump  fsck
#                                                         order

/dev/[xxx]     /            [fff]  defaults         1     1
/dev/[yyy]     swap         swap   pri=1            0     0

# End /etc/fstab
EOF

echo "[clfs]" > /etc/hostname

cat > /etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1 localhost
[192.168.1.1] [<HOSTNAME>.example.org] [HOSTNAME] [alias ...]

# End /etc/hosts (network card version)
EOF

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

domain [Your Domain Name]
nameserver [IP address of your primary nameserver]
nameserver [IP address of your secondary nameserver]

# End /etc/resolv.conf
EOF

cd /etc/systemd/network &&
cat > dhcp.network << "EOF"
[Match]
Name=enp2s0

[Network]
DHCP=yes
EOF

groupadd -g 41 systemd-timesync
useradd -g systemd-timesync -u 41 -d /dev/null -s /bin/false systemd-timesync

systemctl enable systemd-timesyncd

cd /sources
tar -xf boot-scripts-cross-lfs-3.0-20140710.tar.xz
cd boot-scripts-cross-lfs-3.0-20140710

make install

cd /sources
rm -rf boot-scripts-cross-lfs-3.0-20140710

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

echo 3.0.0-SYSTEMD > /etc/clfs-release
