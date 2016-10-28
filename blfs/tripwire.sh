#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Tripwire package containsbr3ak programs used to verify the integrity of the files on a givenbr3ak system.br3ak
#SECTION:postlfs

#REC:openssl
#OPT:mail


#VER:2.4.3.1:null


NAME="tripwire"

wget -nc https://github.com/Tripwire/tripwire-open-source/archive/2.4.3.1.tar.gz


URL=https://github.com/Tripwire/tripwire-open-source/archive/2.4.3.1.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

wget -c https://github.com/Tripwire/tripwire-open-source/archive/2.4.3.1.tar.gz \
     -O tripwire-open-source-2.4.3.1.tar.gz

sed -e 's|TWDB="${prefix}|TWDB="/var|'   \
    -e '/TWMAN/ s|${prefix}|/usr/share|' \
    -e '/TWDOCS/s|${prefix}/doc/tripwire|/usr/share/doc/tripwire-2.4.3.1| \
    -i   install/install.cfg                         &&                     

./configure --prefix=/usr --sysconfdir=/etc/tripwire &&
make


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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
