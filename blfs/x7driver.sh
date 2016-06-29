#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

## Individual drivers starts from here... ##


# Start of driver installation #

#REQ:libevdev
#REQ:xorg-server
#REC:mtdev


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-input-evdev-2.10.2.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-input-evdev-2.10.2.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-evdev-2.10.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:libevdev
#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-input-synaptics-1.8.2.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-input-synaptics-1.8.2.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-synaptics-1.8.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-input-vmmouse-13.0.0.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-input-vmmouse-13.0.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-vmmouse-13.0.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xf86-input-vmmouse-13.0.0-build_fix-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xf86-input-vmmouse-13.0.0-build_fix-1.patch
wget -nc http://www.linuxfromscratch.org/patches/downloads/xf86-input-vmmouse/xf86-input-vmmouse-13.0.0-build_fix-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xf86-input-vmmouse-13.0.0-build_fix-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xf86-input-vmmouse-13.0.0-build_fix-1.patch
wget -nc http://www.linuxfromscratch.org/patches/downloads/xf86-input-vmmouse/xf86-input-vmmouse-13.0.0-build_fix-1.patch
wget -nc http://www.linuxfromscratch.org/patches/downloads/xf86-input-vmmouse/xf86-input-vmmouse-13.0.0-build_fix-1.patch
wget -nc http://www.linuxfromscratch.org/patches/downloads/xf86-input-vmmouse/xf86-input-vmmouse-13.0.0-build_fix-1.patch
wget -nc http://www.linuxfromscratch.org/patches/downloads/xf86-input-vmmouse/xf86-input-vmmouse-13.0.0-build_fix-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../xf86-input-vmmouse-13.0.0-build_fix-1.patch &&
sed -i -e '/__i386__/a iopl(3);' tools/vmmouse_detect.c      &&

./configure $XORG_CONFIG               \
            --without-hal-callouts-dir \
            --without-hal-fdi-dir      \
            --with-udev-rules-dir=/lib/udev/rules.d &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server
#OPT:doxygen
#OPT:graphviz


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/linuxwacom/xf86-input-wacom-0.33.0.tar.bz2

wget -nc http://downloads.sourceforge.net/linuxwacom/xf86-input-wacom-0.33.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG                                \
            --with-udev-rules-dir=/lib/udev/rules.d     \
            --with-systemd-unit-dir=/lib/systemd/system &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-video-ati-7.7.0.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-video-ati-7.7.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-ati-7.7.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/X11/xorg.conf.d/20-glamor.conf << "EOF"
Section "Device"
 Identifier "radeon"
 Driver "ati"
 Option "AccelMethod" "glamor"
EndSection
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-video-fbdev-0.4.4.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-video-fbdev-0.4.4.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-fbdev-0.4.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xcb-util
#REQ:xorg-server


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-0340718.tar.xz

wget -nc http://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-0340718.tar.xz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-0340718.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG --enable-kms-only &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/X11/xorg.conf.d/20-intel.conf << "EOF"
Section "Device"
 Identifier "Intel Graphics"
 Driver "intel"
 Option "AccelMethod" "uxa"
EndSection
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-video-nouveau-1.0.12.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-video-nouveau-1.0.12.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-nouveau-1.0.12.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/X11/xorg.conf.d/nvidia.conf << "EOF"
Section "Device"
 Identifier "nvidia"
 Driver "nouveau"
 Option "AccelMethod" "glamor"
EndSection
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-video-vesa-2.3.4.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-video-vesa-2.3.4.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-vesa-2.3.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/driver/xf86-video-vmware-13.1.0.tar.bz2

wget -nc http://ftp.x.org/pub/individual/driver/xf86-video-vmware-13.1.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-vmware-13.1.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #

echo "x7driver=>`date`" | sudo tee -a $INSTALLED_LIST

