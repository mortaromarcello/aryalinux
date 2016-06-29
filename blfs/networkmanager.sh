#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:NetworkManager:1.0.10

#REQ:dbus-glib
#REQ:libgudev
#REQ:libndp
#REQ:libnl
#REQ:nss
#REC:dhcpcd
#REC:gobject-introspection
#REC:iptables
#REC:libsoup
#REC:newt
#REC:polkit
#REC:systemd
#REC:upower
#REC:vala
#REC:wpa_supplicant
#OPT:bluez
#OPT:gtk-doc
#OPT:ModemManager
#OPT:python-modules#pygobject3
#OPT:qt5
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.0/NetworkManager-1.0.10.tar.xz

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.0/NetworkManager-1.0.10.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/networkmanager/NetworkManager-1.0.10.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/networkmanager/NetworkManager-1.0.10.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/networkmanager/NetworkManager-1.0.10.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.0/NetworkManager-1.0.10.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/networkmanager/NetworkManager-1.0.10.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/networkmanager/NetworkManager-1.0.10.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/Qt[CDN]/s/Qt/Qt5/g'    \
   -e 's/moc_location/host_bins/' \
   -i configure


CXXFLAGS="-O2 -fPIC"     \
./configure --prefix=/usr                   \
            --sysconfdir=/etc               \
            --localstatedir=/var            \
            --with-nmtui                    \
            --disable-ppp                   \
            --with-session-tracking=systemd \
            --with-systemdsystemunitdir=/lib/systemd/system \
            --docdir=/usr/share/doc/NetworkManager-1.0.10    &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/NetworkManager/NetworkManager.conf << "EOF"
[main]
plugins=keyfile
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable NetworkManager

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable NetworkManager-wait-online

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "networkmanager=>`date`" | sudo tee -a $INSTALLED_LIST

