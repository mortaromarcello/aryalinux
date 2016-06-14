#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mod_dnssd:0.6

#REQ:apache
#REQ:avahi
#OPT:lynx


cd $SOURCE_DIR

URL=http://0pointer.de/lennart/projects/mod_dnssd/mod_dnssd-0.6.tar.gz

wget -nc http://0pointer.de/lennart/projects/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -i 's/unixd_setup_child/ap_&/' src/mod_dnssd.c &&
./configure --prefix=/usr \
            --disable-lynx &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
sed -i 's| usr| /usr|' /etc/httpd/httpd.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mod_dnssd=>`date`" | sudo tee -a $INSTALLED_LIST

