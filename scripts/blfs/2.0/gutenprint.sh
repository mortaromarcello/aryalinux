#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cups
#DEP:gimp


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/gimp-print/gutenprint-5.2.10.tar.bz2


TARBALL=gutenprint-5.2.10.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's|$(PACKAGE)/doc|doc/$(PACKAGE)-$(VERSION)|' \
       {,doc/,doc/developer/}Makefile.in &&
./configure --prefix=/usr --disable-static &&
make

cat > 1434987998840.sh << "ENDOFFILE"
make install &&
install -v -dm755 /usr/share/doc/gutenprint-5.2.10/api/gutenprint{,ui2} &&
install -v -m644  doc/gutenprint/html/* \
                  /usr/share/doc/gutenprint-5.2.10/api/gutenprint &&
install -v -m644  doc/gutenprintui2/html/* \
                  /usr/share/doc/gutenprint-5.2.10/api/gutenprintui2
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
systemctl restart org.cups.cupsd
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gutenprint=>`date`" | sudo tee -a $INSTALLED_LIST