#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:sgml-common


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/openjade/OpenSP-1.5.2.tar.gz


TARBALL=OpenSP-1.5.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/32,/253,/' lib/Syntax.cxx &&
sed -i 's/LITLEN          240 /LITLEN          8092/' \
    unicode/{gensyntax.pl,unicode.syn} &&

./configure --prefix=/usr                              \
            --disable-static                           \
            --disable-doc-build                        \
            --enable-default-catalog=/etc/sgml/catalog \
            --enable-http                              \
            --enable-default-search-path=/usr/share/sgml &&

make pkgdatadir=/usr/share/sgml/OpenSP-1.5.2

cat > 1434987998841.sh << "ENDOFFILE"
make pkgdatadir=/usr/share/sgml/OpenSP-1.5.2 \
     docdir=/usr/share/doc/OpenSP-1.5.2      \
     install &&

ln -v -sf onsgmls   /usr/bin/nsgmls   &&
ln -v -sf osgmlnorm /usr/bin/sgmlnorm &&
ln -v -sf ospam     /usr/bin/spam     &&
ln -v -sf ospcat    /usr/bin/spcat    &&
ln -v -sf ospent    /usr/bin/spent    &&
ln -v -sf osx       /usr/bin/sx       &&
ln -v -sf osx       /usr/bin/sgml2xml &&
ln -v -sf libosp.so /usr/lib/libsp.so
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "opensp=>`date`" | sudo tee -a $INSTALLED_LIST