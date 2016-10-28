#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libusb package contains abr3ak library used by some applications for USB device access.br3ak
#SECTION:general

#OPT:doxygen


#VER:libusb:1.0.20


NAME="libusb"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libusb/libusb-1.0.20.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libusb/libusb-1.0.20.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libusb/libusb-1.0.20.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libusb/libusb-1.0.20.tar.bz2 || wget -nc http://downloads.sourceforge.net/libusb/libusb-1.0.20.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libusb/libusb-1.0.20.tar.bz2


URL=http://downloads.sourceforge.net/libusb/libusb-1.0.20.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make -j1

make -C doc docs


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /usr/share/doc/libusb-1.0.20/apidocs &&
install -v -m644    doc/html/* \
                    /usr/share/doc/libusb-1.0.20/apidocs
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
