#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:sgml-common
#DEP:sgml-dtd-3
#DEP:sgml-dtd
#DEP:opensp
#DEP:openjade


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/docbook-dsssl-1.79.tar.bz2
wget -nc http://downloads.sourceforge.net/docbook/docbook-dsssl-doc-1.79.tar.bz2


TARBALL=docbook-dsssl-1.79.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

tar -xf ../docbook-dsssl-doc-1.79.tar.bz2 --strip-components=1

cat > 1434987998842.sh << "ENDOFFILE"
install -v -m755 bin/collateindex.pl /usr/bin                      &&
install -v -m644 bin/collateindex.pl.1 /usr/share/man/man1         &&
install -v -d -m755 /usr/share/sgml/docbook/dsssl-stylesheets-1.79 &&
cp -v -R * /usr/share/sgml/docbook/dsssl-stylesheets-1.79          &&

install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
    /usr/share/sgml/docbook/dsssl-stylesheets-1.79/catalog         &&

install-catalog --add /etc/sgml/dsssl-docbook-stylesheets.cat \
    /usr/share/sgml/docbook/dsssl-stylesheets-1.79/common/catalog  &&

install-catalog --add /etc/sgml/sgml-docbook.cat              \
    /etc/sgml/dsssl-docbook-stylesheets.cat
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
cd /usr/share/sgml/docbook/dsssl-stylesheets-1.79/doc/testdata
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
openjade -t rtf -d jtest.dsl jtest.sgm
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
onsgmls -sv test.sgm
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
openjade -t rtf \
    -d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/print/docbook.dsl \
    test.sgm
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
openjade -t sgml \
    -d /usr/share/sgml/docbook/dsssl-stylesheets-1.79/html/docbook.dsl \
    test.sgm
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh

cat > 1434987998842.sh << "ENDOFFILE"
rm jtest.rtf test.rtf c1.htm
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "docbook-dsssl=>`date`" | sudo tee -a $INSTALLED_LIST