#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:2.4.3.1:null

#REC:openssl


cd $SOURCE_DIR

URL=https://github.com/Tripwire/tripwire-open-source/archive/2.4.3.1.tar.gz

wget -nc https://github.com/Tripwire/tripwire-open-source/archive/2.4.3.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

wget -c https://github.com/Tripwire/tripwire-open-source/archive/2.4.3.1.tar.gz \
     -O tripwire-open-source-2.4.3.1.tar.gz


sed -e 's|TWDB="${prefix}|TWDB="/var|'   \
    -e '/TWMAN/ s|${prefix}|/usr/share|' \
    -e '/TWDOCS/s|${prefix}/doc/tripwire|/usr/share/doc/tripwire-2.4.3.1| \
    -i   install/install.cfg                         &&                     
./configure --prefix=/usr --sysconfdir=/etc/tripwire &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
cp -v policy/*.txt /usr/share/doc/tripwire-2.4.3.1

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

