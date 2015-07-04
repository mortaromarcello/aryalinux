#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/tripwire/tripwire-2.4.2.2-src.tar.bz2


TARBALL=tripwire-2.4.2.2-src.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

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
make

cat > 1434987998750.sh << "ENDOFFILE"
make install &&
cp -v policy/*.txt /usr/share/doc/tripwire-2.4.2.2
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
twadmin --create-polfile --site-keyfile /etc/tripwire/site.key \
    /etc/tripwire/twpol.txt &&
tripwire --init
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
tripwire --check > /etc/tripwire/report.txt
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"

ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
tripwire --update --twrfile /var/lib/tripwire/report/<em class="replaceable"><code><report-name.twr></em>
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
twadmin --create-polfile /etc/tripwire/twpol.txt &&
tripwire --init
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "tripwire=>`date`" | sudo tee -a $INSTALLED_LIST