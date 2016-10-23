#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak NASM (Netwide Assembler) is anbr3ak 80x86 assembler designed for portability and modularity. Itbr3ak includes a disassembler as well.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:nasm:2.12.02
#VER:nasm-xdoc:2.12.02


NAME="nasm"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz || wget -nc http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz || wget -nc http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02-xdoc.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz


URL=http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../nasm-2.12.02-xdoc.tar.xz --strip-components=1


./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -m755 -d         /usr/share/doc/nasm-2.12.02/html  &&
cp -v doc/html/*.html    /usr/share/doc/nasm-2.12.02/html  &&
cp -v doc/*.{txt,ps,pdf} /usr/share/doc/nasm-2.12.02       &&
cp -v doc/info/*         /usr/share/info                   &&
install-info /usr/share/info/nasm.info /usr/share/info/dir

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
