#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:heirloom:070715



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/heirloom/heirloom-070715.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2 || wget -nc http://downloads.sourceforge.net/heirloom/heirloom-070715.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/heirloom/heirloom-070715.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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

sudo rm -rf $DIRECTORY
echo "pax=>`date`" | sudo tee -a $INSTALLED_LIST

