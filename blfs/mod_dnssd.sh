#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The mod_dnssd package is anbr3ak Apache HTTPD module which addsbr3ak Zeroconf support via DNS-SD using Avahi. This allows Apache to advertise itself and the websitesbr3ak available to clients compatible with the protocol.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REQ:apache
#REQ:avahi
#OPT:lynx


#VER:mod_dnssd:0.6


NAME="mod_dnssd"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://0pointer.de/lennart/projects/mod_dnssd/mod_dnssd-0.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mod_dnssd/mod_dnssd-0.6.tar.gz


URL=http://0pointer.de/lennart/projects/mod_dnssd/mod_dnssd-0.6.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/unixd_setup_child/ap_&/' src/mod_dnssd.c &&
./configure --prefix=/usr \
            --disable-lynx &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
sed -i 's| usr| /usr|' /etc/httpd/httpd.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
