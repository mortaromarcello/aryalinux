#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak dhcpcd is an implementation of thebr3ak DHCP client specified in RFC2131. A DHCP client is useful forbr3ak connecting your computer to a network which uses DHCP to assignbr3ak network addresses. dhcpcd strives to be a fully featured, yet verybr3ak lightweight DHCP client.br3ak
#SECTION:basicnet

#OPT:llvm


#VER:dhcpcd:6.11.5


NAME="dhcpcd"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dhcp/dhcpcd-6.11.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dhcp/dhcpcd-6.11.5.tar.xz || wget -nc http://roy.marples.name/downloads/dhcpcd/dhcpcd-6.11.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dhcp/dhcpcd-6.11.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dhcp/dhcpcd-6.11.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dhcp/dhcpcd-6.11.5.tar.xz || wget -nc ftp://roy.marples.name/pub/dhcpcd/dhcpcd-6.11.5.tar.xz


URL=http://roy.marples.name/downloads/dhcpcd/dhcpcd-6.11.5.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --libexecdir=/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd  &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-dhcpcd
cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl start dhcpcd@<em class="replaceable"><code>eth0</em>
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable dhcpcd@<em class="replaceable"><code>eth0</em>
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
