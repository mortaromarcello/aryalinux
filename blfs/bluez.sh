#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:bluez:5.37

#REQ:dbus
#REQ:glib2
#REQ:libical


cd $SOURCE_DIR

URL=http://www.kernel.org/pub/linux/bluetooth/bluez-5.37.tar.xz

wget -nc http://www.kernel.org/pub/linux/bluetooth/bluez-5.37.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluez/bluez-5.37.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluez/bluez-5.37.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bluez/bluez-5.37.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bluez/bluez-5.37.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bluez/bluez-5.37.tar.xz || wget -nc ftp://ftp.kernel.org/pub/linux/bluetooth/bluez-5.37.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/bluez-5.37-obexd_without_systemd-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/bluez/bluez-5.37-obexd_without_systemd-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../bluez-5.37-obexd_without_systemd-1.patch


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-library     &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -svf ../libexec/bluetooth/bluetoothd /usr/sbin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /etc/bluetooth &&
install -v -m644 src/main.conf /etc/bluetooth/main.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/bluez-5.37 &&
install -v -m644 doc/*.txt /usr/share/doc/bluez-5.37

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/bluetooth/rfcomm.conf << "EOF"

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/bluetooth/uart.conf << "EOF"

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable bluetooth

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "bluez=>`date`" | sudo tee -a $INSTALLED_LIST

