#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:opensp


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/openjade/openjade-1.3.2.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/openjade-1.3.2-gcc_4.6-1.patch


TARBALL=openjade-1.3.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../openjade-1.3.2-gcc_4.6-1.patch

sed -i -e '/getopts/{N;s#&G#g#;s#do .getopts.pl.;##;}' \
       -e '/use POSIX/ause Getopt::Std;' msggen.pl

./configure --prefix=/usr                                \
            --mandir=/usr/share/man                      \
            --enable-http                                \
            --disable-static                             \
            --enable-default-catalog=/etc/sgml/catalog   \
            --enable-default-search-path=/usr/share/sgml \
            --datadir=/usr/share/sgml/openjade-1.3.2   &&
make

cat > 1434987998841.sh << "ENDOFFILE"
make install                                                   &&
make install-man                                               &&
ln -v -sf openjade /usr/bin/jade                               &&
ln -v -sf libogrove.so /usr/lib/libgrove.so                    &&
ln -v -sf libospgrove.so /usr/lib/libspgrove.so                &&
ln -v -sf libostyle.so /usr/lib/libstyle.so                    &&

install -v -m644 dsssl/catalog /usr/share/sgml/openjade-1.3.2/ &&

install -v -m644 dsssl/*.{dtd,dsl,sgm}              \
    /usr/share/sgml/openjade-1.3.2                             &&

install-catalog --add /etc/sgml/openjade-1.3.2.cat  \
    /usr/share/sgml/openjade-1.3.2/catalog                     &&

install-catalog --add /etc/sgml/sgml-docbook.cat    \
    /etc/sgml/openjade-1.3.2.cat
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh

cat > 1434987998841.sh << "ENDOFFILE"
echo "SYSTEM \"http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd\" \
    \"/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd\"" >> \
    /usr/share/sgml/openjade-1.3.2/catalog
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "openjade=>`date`" | sudo tee -a $INSTALLED_LIST