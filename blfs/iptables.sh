#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The next part of this chapter deals with firewalls. The principalbr3ak firewall tool for Linux is Iptables. You will need to installbr3ak Iptables if you intend on usingbr3ak any form of a firewall.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser



#VER:iptables:1.6.0


NAME="iptables"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://www.netfilter.org/projects/iptables/files/iptables-1.6.0.tar.bz2 || wget -nc ftp://ftp.netfilter.org/pub/iptables/iptables-1.6.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/iptables/iptables-1.6.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/iptables/iptables-1.6.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/iptables/iptables-1.6.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/iptables/iptables-1.6.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/iptables/iptables-1.6.0.tar.bz2


URL=http://www.netfilter.org/projects/iptables/files/iptables-1.6.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr      \
            --sbindir=/sbin    \
            --disable-nftables \
            --enable-libipq    \
            --with-xtlibdir=/lib/xtables &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sfv ../../sbin/xtables-multi /usr/bin/iptables-xml &&
for file in ip4tc ip6tc ipq iptc xtables
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-iptables

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
