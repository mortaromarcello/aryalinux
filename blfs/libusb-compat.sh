#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libusb-compat package aims tobr3ak look, feel and behave exactly like libusb-0.1. It is a compatibility layer neededbr3ak by packages that have not been upgraded to the libusb-1.0 API.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libusb


#VER:libusb-compat:0.1.5


NAME="libusb-compat"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libusb/libusb-compat-0.1.5.tar.bz2 || wget -nc http://downloads.sourceforge.net/libusb/libusb-compat-0.1.5.tar.bz2


URL=http://downloads.sourceforge.net/libusb/libusb-compat-0.1.5.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST