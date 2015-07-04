#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:sgml-common
#DEP:unzip


cd $SOURCE_DIR

wget -nc http://www.docbook.org/sgml/3.1/docbk31.zip
wget -nc ftp://ftp.kde.org/pub/kde/devel/docbook/SOURCES/docbk31.zip


TARBALL=docbk31.zip
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

mkdir -pv 1434987998841
chmod -R a+rw 1434987998841
cp docbk31.zip 1434987998841
cd 1434987998841
unzip $TARBALL


sed -i -e '/ISO 8879/d' \
       -e 's|DTDDECL "-//OASIS//DTD DocBook V3.1//EN"|SGMLDECL|g' \
       docbook.cat

cat > 1434987998841.sh << "ENDOFFILE"
install -v -d -m755 /usr/share/sgml/docbook/sgml-dtd-3.1 &&
chown -R root:root . &&
install -v docbook.cat /usr/share/sgml/docbook/sgml-dtd-3.1/catalog &&
cp -v -af *.dtd *.mod *.dcl /usr/share/sgml/docbook/sgml-dtd-3.1 &&

install-catalog --add /etc/sgml/sgml-docbook-dtd-3.1.cat \
    /usr/share/sgml/docbook/sgml-dtd-3.1/catalog &&

install-catalog --add /etc/sgml/sgml-docbook-dtd-3.1.cat \
    /etc/sgml/sgml-docbook.cat
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh

cat > 1434987998841.sh << "ENDOFFILE"
cat >> /usr/share/sgml/docbook/sgml-dtd-3.1/catalog << "EOF"
 -- Begin Single Major Version catalog changes --

PUBLIC "-//Davenport//DTD DocBook V3.0//EN" "docbook.dtd"

 -- End Single Major Version catalog changes --
EOF
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh


 
cd $SOURCE_DIR
 
echo "sgml-dtd-3=>`date`" | sudo tee -a $INSTALLED_LIST