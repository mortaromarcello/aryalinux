#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Nano package contains a small,br3ak simple text editor which aims to replace Pico, the default editor in the Pine package.br3ak"
SECTION="postlfs"
VERSION=2.6.3
NAME="nano"

#OPT:slang


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nano/nano-2.6.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nano/nano-2.6.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nano/nano-2.6.3.tar.xz || wget -nc https://www.nano-editor.org/dist/v2.6/nano-2.6.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nano/nano-2.6.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nano/nano-2.6.3.tar.xz


URL=https://www.nano-editor.org/dist/v2.6/nano-2.6.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-2.6.3 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 doc/nanorc.sample /etc &&
install -v -m644 doc/texinfo/nano.html /usr/share/doc/nano-2.6.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
