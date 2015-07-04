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

wget -nc http://www.docbook.org/sgml/4.5/docbook-4.5.zip


TARBALL=docbook-4.5.zip
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

mkdir -pv 1434987998841
chmod -R a+rw 1434987998841
cp docbook-4.5.zip 1434987998841
cd 1434987998841
unzip $TARBALL


sed -i -e '/ISO 8879/d' \
       -e '/gml/d' docbook.cat

cat > 1434987998841.sh << "ENDOFFILE"
install -v -d /usr/share/sgml/docbook/sgml-dtd-4.5 &&
chown -R root:root . &&

install -v docbook.cat /usr/share/sgml/docbook/sgml-dtd-4.5/catalog &&
cp -v -af *.dtd *.mod *.dcl /usr/share/sgml/docbook/sgml-dtd-4.5 &&

install-catalog --add /etc/sgml/sgml-docbook-dtd-4.5.cat \
    /usr/share/sgml/docbook/sgml-dtd-4.5/catalog &&

install-catalog --add /etc/sgml/sgml-docbook-dtd-4.5.cat \
    /etc/sgml/sgml-docbook.cat
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh

cat > 1434987998841.sh << "ENDOFFILE"
cat >> /usr/share/sgml/docbook/sgml-dtd-4.5/catalog << "EOF"
 -- Begin Single Major Version catalog changes --

PUBLIC "-//OASIS//DTD DocBook V4.4//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.3//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.2//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.1//EN" "docbook.dtd"
PUBLIC "-//OASIS//DTD DocBook V4.0//EN" "docbook.dtd"

 -- End Single Major Version catalog changes --
EOF
ENDOFFILE
chmod a+x 1434987998841.sh
sudo ./1434987998841.sh
sudo rm -rf 1434987998841.sh


 
cd $SOURCE_DIR
 
echo "sgml-dtd=>`date`" | sudo tee -a $INSTALLED_LIST