#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The At-Spi2 Core package is a partbr3ak of the GNOME Accessibility Project. It provides a Service Providerbr3ak Interface for the Assistive Technologies available on thebr3ak GNOME platform and a librarybr3ak against which applications can be linked.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:dbus
#REQ:glib2
#REQ:x7lib
#OPT:gobject-introspection
#OPT:gtk-doc


#VER:at-spi2-core:2.22.0


NAME="at-spi2-core"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.22/at-spi2-core-2.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/at-spi/at-spi2-core-2.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/at-spi/at-spi2-core-2.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/at-spi/at-spi2-core-2.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/at-spi/at-spi2-core-2.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.22/at-spi2-core-2.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/at-spi/at-spi2-core-2.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.22/at-spi2-core-2.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --sysconfdir=/etc &&
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