#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Yasm is a complete rewrite of thebr3ak <a class="xref" href="nasm.html" title="NASM-2.12.02">NASM-2.12.02</a> assembler. It supports the x86 andbr3ak AMD64 instruction sets, accepts NASM and GAS assembler syntaxes andbr3ak outputs binary, ELF32 and ELF64 object formats.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:python2
#OPT:python3


#VER:yasm:1.3.0


NAME="yasm"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz || wget -nc http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/yasm/yasm-1.3.0.tar.gz


URL=http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's#) ytasm.*#)#' Makefile.in &&
./configure --prefix=/usr &&
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
