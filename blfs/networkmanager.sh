#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak NetworkManager is a set ofbr3ak co-operative tools that make networking simple and straightforward.br3ak Whether WiFi, wired, 3G, or Bluetooth, NetworkManager allows you tobr3ak quickly move from one network to another: Once a network has beenbr3ak configured and joined once, it can be detected and re-joinedbr3ak automatically the next time it's available.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

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
#OPT:qt5
#OPT:ModemManager
#OPT:python-modules#pygobject3
#OPT:valgrind


#VER:NetworkManager:1.4.2


NAME="networkmanager"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.4/NetworkManager-1.4.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.4/NetworkManager-1.4.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.4/NetworkManager-1.4.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/Qt[CDN]/s/Qt/Qt5/g'       \
    -e 's/moc_location/host_bins/' \
    -i configure


CXXFLAGS="-O2 -fPIC"                                        \
./configure --prefix=/usr                                   \
            --sysconfdir=/etc                               \
            --localstatedir=/var                            \
            --with-nmtui                                    \
            --disable-ppp                                   \
            --with-session-tracking=systemd                 \
            --with-systemdsystemunitdir=/lib/systemd/system \
            --docdir=/usr/share/doc/network-manager-1.4.2 &&
make "-j`nproc`" || make



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
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
