#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Common Unix Printing System (CUPS) is a print spooler andbr3ak associated utilities. It is based on the \"Internet Printingbr3ak Protocol\" and provides printing services to most PostScript andbr3ak raster printers.br3ak"
SECTION="pst"
VERSION=2.1.4
NAME="cups"

#REQ:gnutls
#REC:colord
#REC:dbus
#REC:libusb
#OPT:avahi
#OPT:libpaper
#OPT:linux-pam
#OPT:mitkrb
#OPT:openjdk
#OPT:php
#OPT:python2
#OPT:xdg-utils
#OPT:gutenprint


cd $SOURCE_DIR

URL=https://github.com/apple/cups/releases/download/v2.1.4/cups-2.1.4-source.tar.gz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-2.1.4-source.tar.gz || wget -nc https://github.com/apple/cups/releases/download/v2.1.4/cups-2.1.4-source.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-2.1.4-source.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cups/cups-2.1.4-source.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-2.1.4-source.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-2.1.4-source.tar.gz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 19 lpadmin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


whoami > /tmp/currentuser

sudo usermod -a -G lpadmin `cat /tmp/currentuser`



sed -i 's#@CUPS_HTMLVIEW@#firefox#' desktop/cups.desktop.in


sed -i 's:555:755:g;s:444:644:g' Makedefs.in                          &&
sed -i '/MAN.EXT/s:.gz::g' configure config-scripts/cups-manpages.m4  &&
sed -i '/LIBGCRYPTCONFIG/d' config-scripts/cups-ssl.m4                &&
aclocal  -I config-scripts                                            &&
autoconf -I config-scripts                                            &&
CC=gcc \
./configure --libdir=/usr/lib            \
            --disable-systemd            \
            --with-rcdir=/tmp/cupsinit   \
            --with-system-groups=lpadmin \
            --with-docdir=/usr/share/cups/doc-2.1.4 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
rm -rf /tmp/cupsinit &&
ln -svnf ../cups/doc-2.1.4 /usr/share/doc/cups-2.1.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "ServerName /var/run/cups/cups.sock" > /etc/cups/client.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/cups << "EOF"
# Begin /etc/pam.d/cups
auth include system-auth
account include system-account
session include system-session
# End /etc/pam.d/cups
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
make install-cups

cd $SOURCE_DIR
rm -rf blfs-bootscripts-20160902

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
