#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libgusb package contains thebr3ak GObject wrappers for libusb-1.0br3ak that makes it easy to do asynchronous control, bulk and interruptbr3ak transfers with proper cancellation and integration into a mainloop.br3ak"
SECTION="general"
VERSION=0.2.9
NAME="libgusb"

#REQ:libusb
#REC:gobject-introspection
#REC:usbutils
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://people.freedesktop.org/~hughsient/releases/libgusb-0.2.9.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz || wget -nc http://people.freedesktop.org/~hughsient/releases/libgusb-0.2.9.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgusb/libgusb-0.2.9.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
