#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:nmap:7.12

#REC:libpcap
#REC:pcre
#REC:liblinear
#OPT:openssl
#OPT:python-modules#pygtk
#OPT:python2
#OPT:subversion


cd $SOURCE_DIR

URL=http://nmap.org/dist/nmap-7.12.tar.bz2

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nmap/nmap-7.12.tar.bz2 || wget -nc http://nmap.org/dist/nmap-7.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nmap/nmap-7.12.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nmap/nmap-7.12.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nmap/nmap-7.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nmap/nmap-7.12.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --with-liblua=included &&
make "-j`nproc`"


sed -i 's/lib./lib/' zenmap/test/run_tests.py



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "nmap=>`date`" | sudo tee -a $INSTALLED_LIST

