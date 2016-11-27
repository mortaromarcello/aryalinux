#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak NetworkManager is a set ofbr3ak co-operative tools that make networking simple and straightforward.br3ak Whether WiFi, wired, 3G, or Bluetooth, NetworkManager allows you tobr3ak quickly move from one network to another: Once a network has beenbr3ak configured and joined once, it can be detected and re-joinedbr3ak automatically the next time it's available.br3ak"
SECTION="basicnet"
VERSION=1.4.2
NAME="networkmanager"

#REQ:dbus-glib
#REQ:libgudev
#REQ:libndp
#REQ:libnl
#REQ:nss
#REC:ConsoleKit
#REC:dhcpcd
#REC:gobject-introspection
#REC:iptables
#REC:libsoup
#REC:newt
#REC:polkit
#REC:upower
#REC:vala
#REC:wpa_supplicant
#OPT:bluez
#OPT:gtk-doc
#OPT:qt5
#OPT:ModemManager
#OPT:valgrind
#OPT:dnsmasq
#OPT:libteam
#OPT:ppp
#OPT:rp-pppoe


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.4/NetworkManager-1.4.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.4/NetworkManager-1.4.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.4/NetworkManager-1.4.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/networkmanager/NetworkManager-1.4.2.tar.xz

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
/sbin/usermod -a -G netdev `cat /tmp/currentuser`

sed -e '/Qt[CDN]/s/Qt/Qt5/g'       \
    -e 's/moc_location/host_bins/' \
    -i configure


CXXFLAGS="-O2 -fPIC"                                        \
./configure --prefix=/usr                                   \
            --sysconfdir=/etc                               \
            --localstatedir=/var                            \
            --with-nmtui                                    \
            --disable-ppp                                   \
            --with-systemdsystemunitdir=no                  \
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
cat > /usr/share/polkit-1/rules.d/org.freedesktop.NetworkManager.rules << "EOF"
polkit.addRule(function(action, subject) {
    if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("netdev")) {
        return polkit.Result.YES;
    }
});
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20160902.tar.xz -O $SOURCE_DIR/blfs-bootscripts-20160902.tar.xz
tar xf $SOURCE_DIR/blfs-bootscripts-20160902.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-bootscripts-20160902
make install-networkmanager

cd $SOURCE_DIR
rm -rf blfs-bootscripts-20160902

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
