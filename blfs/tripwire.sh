#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:tripwire-src:2.4.2.2

#REC:openssl


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/tripwire/tripwire-2.4.2.2-src.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tripwire/tripwire-2.4.2.2-src.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tripwire/tripwire-2.4.2.2-src.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tripwire/tripwire-2.4.2.2-src.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tripwire/tripwire-2.4.2.2-src.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tripwire/tripwire-2.4.2.2-src.tar.bz2 || wget -nc http://downloads.sourceforge.net/tripwire/tripwire-2.4.2.2-src.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -i -e 's@TWDB="${prefix}@TWDB="/var@' install/install.cfg            &&
sed -i -e 's/!Equal/!this->Equal/' src/cryptlib/algebra.h                &&
sed -i -e '/stdtwadmin.h/i#include <unistd.h>' src/twadmin/twadmincl.cpp &&
sed -i -e '/TWMAN/ s|${prefix}|/usr/share|' \
       -e '/TWDOCS/s|${prefix}/doc/tripwire|/usr/share/doc/tripwire-2.4.2.2|' \
       install/install.cfg                                               &&
sed -i -e 's/eArchiveOpen e\([^)]*)\)/throw ( eArchiveOpen\1 )/' \
       -e '/throw e;/d' src/core/archive.cpp                             &&
./configure --prefix=/usr --sysconfdir=/etc/tripwire                     &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
cp -v policy/*.txt /usr/share/doc/tripwire-2.4.2.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
twadmin --create-polfile --site-keyfile /etc/tripwire/site.key \
    /etc/tripwire/twpol.txt &&
tripwire --init

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tripwire --check > /etc/tripwire/report.txt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tripwire --update --twrfile /var/lib/tripwire/report/<em class="replaceable"><code><report-name.twr></em>

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
twadmin --create-polfile /etc/tripwire/twpol.txt &&
tripwire --init

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "tripwire=>`date`" | sudo tee -a $INSTALLED_LIST

