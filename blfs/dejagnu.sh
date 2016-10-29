#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak DejaGnu is a framework for runningbr3ak test suites on GNU tools. It is written in <span class="command"><strong>expect</strong>, which uses Tcl (Tool command language). It was installedbr3ak by LFS in the temporary <code class="filename">/toolsbr3ak directory. These instructions install it permanently.br3ak"
SECTION="general"
VERSION=1.6
NAME="dejagnu"

#REQ:expect
#OPT:docbook-utils


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dejagnu/dejagnu-1.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dejagnu/dejagnu-1.6.tar.gz || wget -nc ftp://ftp.gnu.org/pub/gnu/dejagnu/dejagnu-1.6.tar.gz || wget -nc https://ftp.gnu.org/pub/gnu/dejagnu/dejagnu-1.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dejagnu/dejagnu-1.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dejagnu/dejagnu-1.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dejagnu/dejagnu-1.6.tar.gz


URL=https://ftp.gnu.org/pub/gnu/dejagnu/dejagnu-1.6.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi &&
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755   /usr/share/doc/dejagnu-1.6 &&
install -v -m644    doc/dejagnu.{html,txt} \
                    /usr/share/doc/dejagnu-1.6

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
