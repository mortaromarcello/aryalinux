#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Nano package contains a small,br3ak simple text editor which aims to replace Pico, the default editor in the Pine package.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#OPT:slang


#VER:nano:2.6.3


NAME="nano"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nano/nano-2.6.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nano/nano-2.6.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nano/nano-2.6.3.tar.xz || wget -nc https://www.nano-editor.org/dist/v2.6/nano-2.6.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nano/nano-2.6.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nano/nano-2.6.3.tar.xz


URL=https://www.nano-editor.org/dist/v2.6/nano-2.6.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-2.6.3 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 doc/nanorc.sample /etc &&
install -v -m644 doc/texinfo/nano.html /usr/share/doc/nano-2.6.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST