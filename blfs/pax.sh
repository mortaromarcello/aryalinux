#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak pax is an archiving utilitybr3ak created by POSIX and defined by the POSIX.1-2001 standard. Ratherbr3ak than sort out the incompatible options that have crept up betweenbr3ak tar and cpio, along with their implementations acrossbr3ak various versions of UNIX, the IEEE designed a new archive utility.br3ak The name “<span class="quote">pax” is an acronymbr3ak for portable archive exchange. Furthermore, “<span class="quote">pax” means “<span class="quote">peace” in Latin, so its name implies that itbr3ak shall create peace between the tarbr3ak and cpio format supporters. Thebr3ak command invocation and command structure is somewhat a unificationbr3ak of both tar and cpio.br3ak"
SECTION="general"
VERSION=070715
NAME="pax"



wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2 || wget -nc http://downloads.sourceforge.net/heirloom/heirloom-070715.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2


URL=http://downloads.sourceforge.net/heirloom/heirloom-070715.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i build/mk.config                   \
    -e '/LIBZ/s@ -Wl[^ ]*@@g'            \
    -e '/LIBBZ2/{s@^#@@;s@ -Wl[^ ]*@@g}' \
    -e '/BZLIB/s@0@1@'                   &&
make makefiles                           &&
make -C libcommon                        &&
make -C libuxre                          &&
make -C cpio



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 cpio/pax_su3 /usr/bin/pax &&
install -v -m644 cpio/pax.1 /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
