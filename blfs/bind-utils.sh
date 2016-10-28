#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak BIND Utilities is not a separatebr3ak package, it is a collection of the client side programs that arebr3ak included with <a class="xref" href="../server/bind.html" title="BIND-9.11.0">BIND-9.11.0</a>. The BIND package includes the client side programsbr3ak <span class="command"><strong>nslookup</strong>,br3ak <span class="command"><strong>dig</strong> and <span class="command"><strong>host</strong>. If you install BIND server, these programs will be installedbr3ak automatically. This section is for those users who don't need thebr3ak complete BIND server, but needbr3ak these client side applications.br3ak
#SECTION:basicnet

#OPT:libcap
#OPT:libxml2
#OPT:openssl


#VER:bind:9.11.0


NAME="bind-utils"

wget -nc ftp://ftp.isc.org/isc/bind9/9.11.0/bind-9.11.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bind/bind-9.11.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bind/bind-9.11.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bind/bind-9.11.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bind/bind-9.11.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bind/bind-9.11.0.tar.gz


URL=ftp://ftp.isc.org/isc/bind9/9.11.0/bind-9.11.0.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make -C lib/dns &&
make -C lib/isc &&
make -C lib/bind9 &&
make -C lib/isccfg &&
make -C lib/lwres &&
make -C bin/dig


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C bin/dig install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
