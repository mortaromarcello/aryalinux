#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak qemu is a full virtualizationbr3ak solution for Linux on x86 hardware containing virtualizationbr3ak extensions (Intel VT or AMD-V).br3ak"
SECTION="postlfs"
VERSION=2.7.0
NAME="qemu"

#REQ:glib2
#REQ:python2
#REQ:xorg-server
#REC:sdl
#OPT:bluez
#OPT:check
#OPT:curl
#OPT:cyrus-sasl
#OPT:gnutls
#OPT:gtk2
#OPT:gtk3
#OPT:libusb
#OPT:libgcrypt
#OPT:lzo
#OPT:nettle
#OPT:nss
#OPT:mesa
#OPT:sdl
#OPT:vte


cd $SOURCE_DIR

URL=http://wiki.qemu.org/download/qemu-2.7.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qemu/qemu-2.7.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qemu/qemu-2.7.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qemu/qemu-2.7.0.tar.bz2 || wget -nc http://wiki.qemu.org/download/qemu-2.7.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qemu/qemu-2.7.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qemu/qemu-2.7.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

egrep '^flags.*(vmx|svm)' /proc/cpuinfo


if [ $(uname -m) = i686 ]; then
   QEMU_ARCH=i386-softmmu
else
   QEMU_ARCH=x86_64-softmmu
fi
mkdir -vp build &&
cd        build &&
../configure --prefix=/usr               \
             --sysconfdir=/etc           \
             --target-list=$QEMU_ARCH    \
             --audio-drv-list=alsa       \
             --docdir=/usr/share/doc/qemu-2.7.0 &&
unset QEMU_ARCH &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 61 kvm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


whoami > /tmp/currentuser
sudo usermod -a -G kvm `cat /tmp/currentuser`




sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /lib/udev/rules.d/65-kvm.rules << "EOF"
KERNEL=="kvm", GROUP="kvm", MODE="0660"
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -sv qemu-system-`uname -m` /usr/bin/qemu

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


qemu-img create -f qcow2 vdisk.img 10G


qemu -enable-kvm -hda vdisk.img            \
     -cdrom Fedora-16-x86_64-Live-LXDE.iso \
     -boot d                               \
     -m 384


qemu -enable-kvm vdisk.img -m 384


qemu -enable-kvm             \
     -cdrom /home/fernando/ISO/linuxmint-17.1-mate-32bit.iso \
     -boot order=d           \
     -m 1G,slots=3,maxmem=4G \
     -machine smm=off        \
     -soundhw es1370         \
     -cpu host               \
     -smp cores=4,threads=2  \
     -vga std                \
     vdisk.img


qemu -enable-kvm             \
     -machine smm=off        \
     -boot order=d           \
     -m 1G,slots=3,maxmem=4G \
     -soundhw es1370         \
     -cpu host               \
     -smp cores=4,threads=2  \
     -vga vmware             \
     -hda vdisk.img



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /usr/share/X11/xorg.conf.d/20-vmware.conf << "EOF"
Section "Monitor"
 Identifier "Monitor0"
 # cvt 1600 900
 # 1600x900 59.95 Hz (CVT 1.44M9) hsync: 55.99 kHz; pclk: 118.25 MHz
 Modeline "1600x900" 118.25 1600 1696 1856 2112 900 903 908 934 -hsync +vsync
 Option "PreferredMode" "1600x900"
 HorizSync 1-200
 VertRefresh 1-200
EndSection
Section "Device"
 Identifier "VMware SVGA II Adapter"
 Option "Monitor" "default"
 Driver "vmware"
EndSection
Section "Screen"
 Identifier "Default Screen"
 Device "VMware SVGA II Adapter"
 Monitor "Monitor0"
 SubSection "Display"
 Depth 24
 Modes "1600x900" "1440x900" "1366x768" "1280x720" "800x480"
 EndSubSection
EndSection
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sysctl -w net.ipv4.ip_forward=1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/sysctl.conf << EOF
net.ipv4.ip_forward=1
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chgrp kvm  /usr/libexec/qemu-bridge-helper &&
chmod 4750 /usr/libexec/qemu-bridge-helper

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo 'allow br0' > /etc/qemu/bridge.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
