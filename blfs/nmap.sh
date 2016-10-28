#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Nmap is a utility for networkbr3ak exploration and security auditing. It supports ping scanning, portbr3ak scanning and TCP/IP fingerprinting.br3ak
#SECTION:basicnet

#REC:libpcap
#REC:pcre
#REC:liblinear
#OPT:openssl
#OPT:python-modules#pygtk
#OPT:python2
#OPT:subversion


#VER:nmap:7.31


NAME="nmap"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nmap/nmap-7.31.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nmap/nmap-7.31.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nmap/nmap-7.31.tar.bz2 || wget -nc http://nmap.org/dist/nmap-7.31.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nmap/nmap-7.31.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nmap/nmap-7.31.tar.bz2


URL=http://nmap.org/dist/nmap-7.31.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --with-liblua=included &&
make

sed -i 's/lib./lib/' zenmap/test/run_tests.py


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
