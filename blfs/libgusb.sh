#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The libgusb package contains thebr3ak GObject wrappers for libusb-1.0br3ak that makes it easy to do asynchronous control, bulk and interruptbr3ak transfers with proper cancellation and integration into a mainloop.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libusb
#REC:gobject-introspection
#REC:usbutils
#REC:vala
#OPT:gtk-doc


#VER:libgusb:0.2.9


NAME="libgusb"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz || wget -nc http://people.freedesktop.org/~hughsient/releases/libgusb-0.2.9.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz


URL=http://people.freedesktop.org/~hughsient/releases/libgusb-0.2.9.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
