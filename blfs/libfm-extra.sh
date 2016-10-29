#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libfm-extra package contains abr3ak library and other files required by <span class="command"><strong>menu-cache-gen</strong> libexec ofbr3ak <a class="xref" href="menu-cache.html" title="menu-cache-1.0.1">menu-cache-1.0.1</a>.br3ak"
SECTION="lxde"
VERSION=1.2.4
NAME="libfm-extra"

#REQ:glib2


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz || wget -nc http://downloads.sourceforge.net/pcmanfm/libfm-1.2.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz


URL=http://downloads.sourceforge.net/pcmanfm/libfm-1.2.4.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-extra-only \
            --with-gtk=no     \
            --disable-static  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
