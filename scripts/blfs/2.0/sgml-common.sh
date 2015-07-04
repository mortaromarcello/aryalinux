#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://sources.redhat.com/pub/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/sgml-common-0.6.3-manpage-1.patch


TARBALL=sgml-common-0.6.3.tgz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../sgml-common-0.6.3-manpage-1.patch &&
autoreconf -f -i

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998841.sh << "ENDOFFILE"
make docdir=/usr/share/doc install &&

install-catalog --add /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&

install-catalog --add /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh

cat > 1434987998841.sh << "ENDOFFILE"
install-catalog --remove /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&

install-catalog --remove /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "sgml-common=>`date`" | sudo tee -a $INSTALLED_LIST