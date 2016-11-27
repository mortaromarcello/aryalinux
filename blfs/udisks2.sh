#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak  The UDisks package provides a daemon,br3ak tools and libraries to access and manipulate disks and storage devices.br3ak"
SECTION="general"
VERSION=2.1.7
NAME="udisks2"

#REQ:libatasmart
#REQ:libgudev
#REQ:libxslt
#REQ:polkit
#REQ:sg3_utils
#OPT:gobject-introspection
#OPT:gptfdisk
#OPT:gtk-doc
#OPT:ntfs-3g
#OPT:parted
#OPT:dosfstools


cd $SOURCE_DIR

URL=http://udisks.freedesktop.org/releases/udisks-2.1.7.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://udisks.freedesktop.org/releases/udisks-2.1.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/udisks/udisks-2.1.7.tar.bz2 || wget -nc http://hal.freedesktop.org/releases/udisks-2.1.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/udisks/udisks-2.1.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-2.1.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-2.1.7.tar.bz2

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

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
