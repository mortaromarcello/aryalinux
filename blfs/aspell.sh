#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Aspell package contains anbr3ak interactive spell checking program and the Aspell libraries. Aspell can either be used as a library or asbr3ak an independent spell checker.br3ak
#SECTION:general

#REQ:general_which


#VER:aspell:0.60.6.1


NAME="aspell"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz || wget -nc https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/aspell/aspell-0.60.6.1.tar.gz


URL=https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -svfn aspell-0.60 /usr/lib/aspell &&

install -v -m755 -d /usr/share/doc/aspell-0.60.6.1/aspell{,-dev}.html &&

install -v -m644 manual/aspell.html/* \
    /usr/share/doc/aspell-0.60.6.1/aspell.html &&

install -v -m644 manual/aspell-dev.html/* \
    /usr/share/doc/aspell-0.60.6.1/aspell-dev.html
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 scripts/ispell /usr/bin/
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 scripts/spell /usr/bin/
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
