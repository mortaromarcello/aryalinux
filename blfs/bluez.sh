#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The BlueZ package contains thebr3ak Bluetooth protocol stack for Linux.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:dbus
#REQ:glib2
#REQ:libical


#VER:bluez:5.42


NAME="bluez"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bluez/bluez-5.42.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bluez/bluez-5.42.tar.xz || wget -nc http://www.kernel.org/pub/linux/bluetooth/bluez-5.42.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluez/bluez-5.42.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bluez/bluez-5.42.tar.xz || wget -nc ftp://ftp.kernel.org/pub/linux/bluetooth/bluez-5.42.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluez/bluez-5.42.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/bluez/bluez-5.42-obexd_without_systemd-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/bluez-5.42-obexd_without_systemd-1.patch


URL=http://www.kernel.org/pub/linux/bluetooth/bluez-5.42.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../bluez-5.42-obexd_without_systemd-1.patch


./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --enable-library      &&
make "-j`nproc`" || make



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
install -v -dm755 /usr/share/doc/bluez-5.42 &&
install -v -m644 doc/*.txt /usr/share/doc/bluez-5.42

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
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
