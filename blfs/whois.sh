#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:whois_:5.2.11

#OPT:libidn


cd $SOURCE_DIR

URL=http://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.11.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/whois/whois_5.2.11.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/whois/whois_5.2.11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/whois/whois_5.2.11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/whois/whois_5.2.11.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/whois/whois_5.2.11.tar.xz || wget -nc http://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.11.tar.xz || wget -nc ftp://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.11.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install-whois
make prefix=/usr install-mkpasswd
make prefix=/usr install-pos

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "whois=>`date`" | sudo tee -a $INSTALLED_LIST

